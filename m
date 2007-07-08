Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbXGHQYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbXGHQYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 12:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXGHQX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 12:23:58 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:23185 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754572AbXGHQX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 12:23:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PwSDDjamQiekItrl/gVblUgF+DhFUpanpj4rIkKLXgEUQgDnXuEUagOlwGR/eXoWgy+s7bAEPxu55FAQX3oOy3Tms4ng+3yDiVGWaxqLkiB1a4RqU77CJG7fu1+4SRQkm+ESD8a5HqBNJ/jrrhkoWB5UHEHHokGdAGFrrWRL7mQ=  ;
X-YMail-OSG: nSO8lMEVM1kBOgjc4tKXosVRcYs156dglvoclyLWnSQ6mXcxLsIbLBQED1XZ9SGJrVRmEZ2z8g--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
Date: Sun, 8 Jul 2007 09:23:54 -0700
User-Agent: KMail/1.9.6
Cc: Al Viro <viro@ftp.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       mjg59@srcf.ucam.org, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
References: <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070708123748.GB3866@ucw.cz> <20070708135829.GF21668@ftp.linux.org.uk>
In-Reply-To: <20070708135829.GF21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707080923.54998.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 July 2007, Al Viro wrote:
> On Sun, Jul 08, 2007 at 12:37:48PM +0000, Pavel Machek wrote:
> > I'm talking malicious _filesystems_ here, and yes, fuse is first of
> > this kind. We want to handle unresponding NFS, but I believe handling
> > malicious NFS server nicely is slightly out of scope.
> 
> If your variant doesn't handle compromised NFS server, your variant is
> needs to be fixed...

That would depend on the type of compromise, right?

Remember that the fundamental contract between a client and
a server includes the client extending some trust to that
server.  Whether it's appropriate to extend that trust (at
any given moment) is an out-of-band security issue.  Trust
is not a protocol issue ... more like an operational issue,
and only slightly an implementation issue.

A malicious filesystem could do many things.  It could send
private data off to someone who wasn't intended to receive
that data.  It could return falsified data.  It could do any
variety of things outside the protocol specification...

And *MOST* of those would be impractical to defend against
in code.  Which is why I have such a hard time agreeing
with your comment about "fixing" a client that doesn't try
to defend itself.  (Unless by "client" you also include the
whole operational side of the client, including regular
re-validation of the trust extended to that server... which
would at best minimize damage caused by compromises.)



