Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbXJOKNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbXJOKNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbXJOKNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:13:23 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:34605 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757646AbXJOKNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:13:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qN81VBpUaxZGfxTZOcBUD6TvozKFxnUtZBkRrKiWAUAshXVWyEQwbY3jkRok93mUPxZNqSn3BPv/kjMTo2iyQXdPKusPZrMZSyZDlUZ9kAjvUxQL/iW43TsFWmFwLAxy10Qxv/dM8CyLqQbZjxk5CNEEGLdiB1Tdq+WPus+AFlk=  ;
X-YMail-OSG: k0Pz3gYVM1nmbCp2NOW0Tq9OZCrUd6KpdgtqGbIMJXcs9rf9
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] ramdisk: fix zeroed ramdisk pages on memory pressure
Date: Tue, 16 Oct 2007 01:23:32 +1000
User-Agent: KMail/1.9.5
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710160006.19735.nickpiggin@yahoo.com.au> <20071015021624.7d5233bd.akpm@linux-foundation.org>
In-Reply-To: <20071015021624.7d5233bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160123.32434.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 19:16, Andrew Morton wrote:
> On Tue, 16 Oct 2007 00:06:19 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Monday 15 October 2007 18:28, Christian Borntraeger wrote:
> > > Andrew, this is a resend of a bugfix patch. Ramdisk seems a bit
> > > unmaintained, so decided to sent the patch to you :-).
> > > I have CCed Ted, who did work on the code in the 90s. I found no
> > > current email address of Chad Page.
> >
> > This really needs to be fixed...
>
> rd.c is fairly mind-boggling vfs abuse.

Why do you say that? I guess it is _different_, by necessity(?)
Is there anything that is really bad? I guess it's not nice
for operating on the pagecache from its request_fn, but the
alternative is to duplicate pages for backing store and buffer
cache (actually that might not be a bad alternative really).
