Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbYDNSw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbYDNSw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965213AbYDNSrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:47:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209AbYDNSry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:47:54 -0400
Message-ID: <48038DBE.7010203@zytor.com>
Date: Mon, 14 Apr 2008 10:00:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       neilb@suse.de, htejun@gmail.com, lkml@rtr.ca
Subject: Re: [PATCH] sysfs: add /sys/dev/{char,	block} to lookup sysfs path
 by major:minor
References: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20080414165036.13697.6532.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> 
> What are the alternatives?:
> 1/ Add an ioctl to return the path: Doable, but sysfs is meant to reduce
>    the need to proliferate ioctl interfaces into the kernel, so this
>    seems counter productive.
> 
> 2/ Use udev to create these symlinks: Also doable, but it adds a
>    udev dependency to utilities that might be running in a limited
>    environment like an initramfs.
> 

3, of course, is what applications have to do today, which is to do a 
full-tree search of sysfs.

Given that this appears to be fairly little code it would make sense to 
me; one could argue if /sys/dev/block/8/32 would be better than 
/sys/dev/block/8:32, but (a) I don't think it matters and (b) the 
non-atomicity of the former would

	-hpa
