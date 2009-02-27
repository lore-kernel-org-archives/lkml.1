Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZB0O1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZB0O1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZB0O1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:27:40 -0500
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:44810 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbZB0O1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:27:40 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/8] Aufs2 documents 
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235668827.15148.422.camel@moss-terrapins.epoch.ncsc.mil>
References: <7558.1235374266@jrobl> <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil> <7390.1235624062@jrobl> <1235668827.15148.422.camel@moss-terrapins.epoch.ncsc.mil>
Date: Fri, 27 Feb 2009 23:27:17 +0900
Message-ID: <16503.1235744837@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"David P. Quigley":
> an EOPNOTSUPP back. Considering things such as ACLs and SELinux labels
> are stored in xattrs it seems that failing a copyup on EOPNOTSUPP is a
> very reasonable thing to do.

Do you mean ... ?
- if aufs and its lower branch fs support xattr but its upper branch
  doesn't, then some of copyup will fail.
- that is user's choice.


> > Finally I am considering to make some levels to support xattr.
> > - support minimum common set of key only (if such set exists)
> >   Here "minimum common set" means a group of key which are surely
> >   supported by all filesystems. Aufs will filter-out other keys.
> > - create a new internal status flag
> >   This flag is set when the type of all branches are same. When the flag
> >   is set, aufs will handle xattr by simply redirecting.
> > - create a new aufs mount option
> >   the option will select two behaviours (above).
> 
> So I don't think this is a good way of going about it. The idea of
> having some flag which indicates just relay to the lower filesystems if
> they are all the same completely ignores that you may have several file
> systems which all support the required namespaces. One example I can

When all branch filesystems support the required xattr even if thier
filesystem-type differ, user can specify the mount option (the thrid
level above) and all xattr will be handled. When any of xattr are not
supported by the upper branch fs, then copyup will fail.
Do I make my clear, or do I misunderstand you?


> If you have more questions about this feel free to ask. I don't have
> time to actually do work in this space but I can answer whatever
> questions you have.

I am afraid I don't fully understand what you wrote.
According to linux/Documentation/Smack.txt, "xattr support is not
strictly required". But for selinux (or other security mechanism), xattr
is neccessary as you wrote.
Please tell me the url where I should know about security label or
type. Particulary "iso9660_t" type, I don't know what it is.
And do you believe the lack of supporting xattr is critical for aufs to
be merged?


J. R. Okajima
