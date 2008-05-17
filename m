Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYEQCG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYEQCG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 22:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYEQCGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 22:06:19 -0400
Received: from vsmtp01.dti.ne.jp ([202.216.231.136]:57256 "EHLO
	vsmtp01.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYEQCGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 22:06:18 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/67] aufs document 
To: Dave Quigley <dpquigl@tycho.nsa.gov>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1210954152.14706.50.camel@moss-terrapins.epoch.ncsc.mil>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <1210949976.14706.28.camel@moss-terrapins.epoch.ncsc.mil> <18952.1210952732@jrobl> <1210954152.14706.50.camel@moss-terrapins.epoch.ncsc.mil>
Date: Sat, 17 May 2008 11:06:11 +0900
Message-ID: <7328.1210989971@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Quigley:
> It is fine to have an overall document describing your FS but there are
> things you have missing. For example patch 62. Why do you have magic
> sysreq handling? What does it do? What problem is it solving? This isn't
> in your 01 patch and I can't tell its purpose at all from the patch.

It simply dumps some aufs status to console. Because I think it is a
nature of magic sysrq, and it is not a feature to solve a specific
problem, I didn't write much, just simply 
----------------------------------------------------------------------
.B sysrq=key
Specifies MagicSysRq key for debugging aufs.
You need to enable both of CONFIG_MAGIC_SYSRQ and CONFIG_AUFS_DEBUG.
If your linux version is linux\-2.6.24 and earlier, you need to enable
CONFIG_AUFS_SYSAUFS too.
Currently this is for developers only.
The default is `a'.
----------------------------------------------------------------------
in the aufs manual.


> Another example is what are your sysfs entries for? A description of
> what they are for in either the main doc or as a patch comment is
> necessary. Why is your sysfs functionality broken out into two patches?

One of them is for lifetime management as the description
said. Generally an object correspoing to an entry might be under sysfs
is managed by kref. This management is independent from CONFIG_SYSFS,
and the former patch is compiled unconditionally.
The other is for the actual entires under sysfs, and compiled when SYSFS
is enabled only.
I don't think it is a good idea to make them in a single patch.

But I will re-send the entire aufs patch series in next week, after...
- make some simple header + source pairs in a single patch and try more
  description text, as you pointed out.
- remove some lines unnecessary for -mm tree, pointed out by Jan
  Engelhardt and Sam Ravnborg.
- future other things if someone will point out.


> The point of posting these sets to LKML is so people will review them.
> If I have to read through a large document and then through each patch
> individually just to figure out what the patch is trying to accomplish
> before I can see how it is going about accomplishing it, then that is
> extra resistance to actually looking through the set.

I tried to do so...
I thought first document is important too, but the smaller patches in
the later is more preferable than larger ones. Addionally most of them
are totally new files. So I chose "one patch by one new file" way.

Anyway, I will re-send them in next week after trying some grouping.


Thank you
Junjiro Okajima
