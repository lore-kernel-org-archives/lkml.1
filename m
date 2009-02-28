Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbZB1IEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbZB1IEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZB1IE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:04:26 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:49816 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZB1IEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:04:25 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 0/8] Aufs2 documents 
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1235758633.15148.448.camel@moss-terrapins.epoch.ncsc.mil>
References: <7558.1235374266@jrobl> <1235584254.15148.86.camel@moss-terrapins.epoch.ncsc.mil> <7390.1235624062@jrobl> <1235668827.15148.422.camel@moss-terrapins.epoch.ncsc.mil> <16503.1235744837@jrobl> <1235758633.15148.448.camel@moss-terrapins.epoch.ncsc.mil>
Date: Sat, 28 Feb 2009 17:04:12 +0900
Message-ID: <11466.1235808252@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"David P. Quigley":
> I mean that in the event that an xattr can't be copied up to the next
> read-write branch the copyup should fail. Otherwise you get the
	:::
> I can see an "I know better" mount option being useful for this. I
> understand what you're trying to do now.

Then I don't see difference between what you wrote and my idea.
I think I should assert first that aufs doesn't support xattr currently.


> The point I was trying to make with iso9660_t is that since the xattr
> interface is what is used for security labels regardless of whether the
> underlying file system actually supports xattrs there are other places
> that the security label may come from. Since an iso9660 file system does
> not support extended attributes SELinux has a fixed type for all content
> on that file system. When someone asks for security.selinux on an
> iso9660 file system it goes to the inode, takes the security context in
> there, and converts it into the string you see even though there is no
> real xattr support.

For example, on a system which adopts selinux, if a user copies a file
manually from iso9660 (or other fs which doesn't support xattr) to a
xattr-supported fs, then he will not meet a security risk.
Is it correct?

And in the reverse case, copying a file manually from an xattr-supported
fs to non-supported fs may drop security info. Since this is manual
operation, user should know the risk. Right?
Here what will be security.selinux for the copied file?
Will it be set to the default value which is defined by a global policy
or something?
If it is true, then what will happen when the global policy has the
highest security level? User will not meet a security risk either?
Or such policy is useless in real world because of too low usability?

While these questions may sound silly, I just want to know how the
protection will be damaged in detail. Still I don't know much about
selinux.
I understand the case you want to clarify which aufs copies file
internally instead of manually. But will you tell me the comparision
between internal file copy and manual copy?

Anyway I guess aufs should support xattr in the future. I just want to
fix its priority, particulary it has to be implemented before
review/merge.


J. R. Okajima
