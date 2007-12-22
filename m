Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXLVLL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXLVLL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 06:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXLVLLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 06:11:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:30552 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXLVLLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 06:11:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:x-mailer:x-operating-system:user-agent;
        b=DWpyZoTCa2QrQs0/OwD1ChBHTSap8nCTJawxSx32gLuSSDgkLJR4B7W8eN8499ez3r65AbhqKAhvQm2IBzYz37SHJmduOS0Kml96ZH/xDcFts8Gt0vmD3COOrfKMopTXeIgtY+Wh+bkZ5JA0hGGUDFd5NH+jOB4t8sIBzoOLk9A=
Date: Sun, 23 Dec 2007 03:15:42 +0800
From: Zhenyu Wang <zhen78@gmail.com>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org, xorg@lists.freedesktop.org
Subject: Re: linux-2.6.24-rcX regression / xserver-xorg-video-intel / Q35
Message-ID: <20071222191542.GA17055@localdomain>
References: <20071222002516.GR6625@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222002516.GR6625@prithivi.gnumonks.org>
X-Mailer: mutt
X-Operating-System: Linux 2.6.24-rc3 unknown
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.12.22 01:25:16 +0100, Harald Welte wrote:
> 
> I'm running an Intel DQ35JO mainboard (Q35 chipset, Q6600 CPU) and I am
> observing a regression with linux-2.6.24-rc1 through -rc6 (linux-2.6.git as
> of today, ea67db4cdbbf7f4e74150e71da0984e25121f500).
> 
> The last working version is 2.6.24-rc1.
> 
> The system is running debian unstable (current) using
> xserver-xorg-video-intel 2.2.0-1
> 
> So what is the actual problem:
> It seems to be related to the way how the iommu/gart is used for memory
> allocation of the framebuffer memory.

There's no behavior change in intel agp module between .24-rc1 to rc6.
IOMMU shouldn't matter here, if you build x86_64 system and with
CONFIG_DMAR on, you should be already having CONFIG_DMAR_GFX_WA for you.

> 
> Xorg starts just as it should, but the lower part of the screen is
> completely gobbled.  I suppose the lower part of the screen is actually
> showing off-screen memory at some completely differnt location.

Do you have other changes except kernel? like other xorg packages, bios?

> 
> Interestingly, the mouse cursor is superimposed on top of the garbage
> (and it is not distorted).

yeah, hardware cursor uses another plane than scan buffer, it's
seperate.

Could you fire a bug to https://bugs.freedesktop.org with versions and
logs? Thanks.

