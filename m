Return-Path: <linux-kernel-owner+w=401wt.eu-S1760542AbXGDVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760542AbXGDVa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 17:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbXGDVaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 17:30:11 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:60019 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469AbXGDVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 17:30:08 -0400
Message-ID: <468C1157.70905@kernel.org>
Date: Wed, 04 Jul 2007 14:29:59 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: implement-file-posix-capabilities.patch
References: <20070611123714.GA2063@sergelap.austin.ibm.com> <878322.98602.qm@web36606.mail.mud.yahoo.com> <afff21250706110926l244ddc28i44289cb08a6721e2@mail.gmail.com> <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070702143816.GA17723@vino.hallyn.com>
In-Reply-To: <20070702143816.GA17723@vino.hallyn.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
> 1. Exactly Andrew describes.  Once userspace switches to a new cap
> format, an older kernel simply won't support them

Mmm. Let me see. I think I prefer this one! :-)

> 2. As Andrew describes, but also encode the version number into the
> capability name, i.e. security.capability.v3.  Now userspace can
> optionally tack on more than one capability version to be backward
> compatible.

If you have a significant legacy of use of earlier versions, I guess
this makes sense. However, given the experimental nature of this support
(it will be a while before the user space support for this is
secure/robust), I'm not all that concerned about legacy support.

> 3. Somewhat different than Andrew describes.  We mandate that any
> capability version N+1 consist of
> 
> struct vfs_cap_data {
> 	__u32 magic;
> 	capability_version_1;
> 	capability_version_2;
> 	...
> 	capability_version_N;
> 	capability_version_N+1;
> };

Ugh. I don't like this. It presumes that the kernel will get more and
more complicated over time. Please don't do this one.

> Or, for brevity,
> 
> struct vfs_cap_data {
> 	__u32 first_magic;
> 	__u32 last_magic;
> 	capability_version_first;
> 	...
> 	capability_version_last;
> };
> 
> 4. Stick to the current plan, where switching to 64-bit caps will be
> done as
> 
> struct vfs_cap_data_disk {
> 	__le32 version;
> 	__le32 data[]; /* eff[0], perm[0], inh[0], eff[1], ... */
> };

While asserting that it is more flexible etc., no one has yet actually
given an example of where fE being richer than a simple binary helps
anything. Until I see an example, I'm going to hold the position that
this is needless "complexity".

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGjBFXmwytjiwfWMwRAofJAKCXX2GkN39o45fCQmxpNpZIEVH8EgCeLaDy
AoWZNj/1MqT7oayabxUhIn8=
=OSBu
-----END PGP SIGNATURE-----
