Return-Path: <linux-kernel-owner+w=401wt.eu-S1760972AbYAaBbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760972AbYAaBbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 20:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYAaBa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 20:30:57 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:2517 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYAaBa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 20:30:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tMdXzc4ldTypq8E0dMV4B1knRBrW0ub6KGcBzVE3qRjxw3WK9ubVqVIrx0rESz75IOsav6WDBDrzLLSRkBkdTBEhUOGymsA92yXtLw0K+gZYLu5sXNike2HMbqGMIuazjKcL4gHkVBjM794f46HdgKfH1SnnzQOo7V5YBnLFxTM=
Message-ID: <524f69650801301730m42abca6dn76d21fbdddbe89b5@mail.gmail.com>
Date: Wed, 30 Jan 2008 19:30:55 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [2.6 patch] remove smbfs
Cc: "Adrian Bunk" <bunk@kernel.org>, "Guenter Kukkukk" <linux@kukkukk.com>,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       sfrench@samba.org
In-Reply-To: <20080130201350.7a576203@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080128220835.GF8767@does.not.exist>
	 <200801302216.13788.linux@kukkukk.com>
	 <20080130174103.17ff8197@tleilax.poochiereds.net>
	 <20080130225810.GU29368@does.not.exist>
	 <20080130193412.61c6e2e9@tleilax.poochiereds.net>
	 <20080131004717.GX29368@does.not.exist>
	 <20080130201350.7a576203@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 7:13 PM, Jeff Layton <jlayton@redhat.com> wrote:
> On Thu, 31 Jan 2008 02:47:17 +0200
> > > > > > In addition, cifs cannot completely replace smbfs atm.
> > > > > > Even todays sold NAS-boxes (often running anchient
> > > > > > samba-2.x.x) work only with smbfs on the client side.
I am not convinced that this (mounting to older servers) would be a
problem with the proper mount options but it is more intuitive for
smbfs for some of the lanman servers.   I do want to make sure that we
don't make it too easy to mount with insecure lanman (ie due to
downgrade attacks) without the user at least doing that (specify weak
lanman security explicitly).  Today the user has to explicitly specify
sec=lanman which is confusing but at least makes explicit the weaker
security.

There are four common issues with mounting to these very old servers:
1) remembering to mount specifying lanman security (sec=lanman)
2) remembering to specify the netbios name of the server on mount
(which is often not be the same as its tcp name) - we can make this
easier in mount.cifs though
3) some missing function (mostly relating to converting unix time to
DOS time for set time functions, although the other way around works)
4) working around various server bugs (a surprising number of these)

> > > > > It would be ideal if someone were to report these problems as
> > > > > bugs. I remember some of those in the past, but haven't heard
> > > > > of any cases of that sort of thing for some time. When I have,
> > > > > Steve has generally been very good about tracking down the
> > > > > cause and fixing it.
> > > >
> > > > More exactly, one of the main advantages of removing redundant
> > > > code like smbfs is that people are finally forced to report their
> > > > bugs.




-- 
Thanks,

Steve
