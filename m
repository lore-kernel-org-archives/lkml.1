Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbXELTvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbXELTvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXELTvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:51:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:1620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbXELTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iWdgVKQbzkCH5AKx56kSI50eA+U1Wlwo31a1Tx/PrlzLdlc9rpp1YxAbrPBSns34b2C0Nl+WhSXNuzdwXEYh8owL6VlFh44Ab+WoIQAuaoZW2TTzAsIHt2D+/AtLYtag8ITExkNA3rxFZ6Gt4YFn2k/KrNRoai4zFSYUyvm+DXs=
Message-ID: <a781481a0705121251o5faedbc2ybfef61efdee90864@mail.gmail.com>
Date: Sun, 13 May 2007 01:21:13 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jindrich Makovicka" <makovick@gmail.com>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070512134144.5bb29544@holly>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1785450541@web.de> <20070512134144.5bb29544@holly>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jindrich,

On 5/12/07, Jindrich Makovicka <makovick@gmail.com> wrote:
> On Sat, 12 May 2007 12:41:03 +0200
> devzero@web.de wrote:
>
> > oh - and think of linux software suspend.
> > take a notebook with 2 GB of ram - that takes a while to write that
> > to disk and read that back again. using lzo compression for this may
> > probably halve the time for suspend/resume
>
> There were already some attempts on merging of the lzf algorithm:
>
> http://lkml.org/lkml/2006/6/26/215

Hmmm ... that thread had some really neat and simple kernel-compliant
code, but it wanted to bring in a different compression algo :-) LZF, LZO,
LZW are all different.

> Also, ffmpeg/libavcodec contains a much cleaner implementation of LZO

Yeah, I hope the discussion here shifts (after the copyright issues
are resolved,
of course) to the submitted code itself. It's a compression library
also linked to
cryptoapi, so would definitely find users for itself -- this was later
submitted as
a patchset containing the JFFS2 glue code too.

But what I'm not sure about is the suitability of _this_ implementation to be
merged AS IS (~2500 lines of non-kernel-style, and even pointless, code is
no small thing) without a proper conversion / port to the kernel.

The upsides of a proper port would be nice: I suspect ~500 LOC in those
two headers would vanish, and perhaps an equal number in lzo.c (it even
re-invents memset, memcpy, etc for itself!).

The downside, as Richard said, would be that the kernel's LZO is no longer
diff-able with minilzo (the userspace library) which means someone who
takes on maintainership of this will have more work to do. (but how much
more would it be anyway?)

> decompressor, with comparable performance (but no compressor yet I am
> afraid).

Satyam
