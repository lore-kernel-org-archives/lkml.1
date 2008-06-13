Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYFMLFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYFMLFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYFMLFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:05:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:40058 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYFMLFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Xh+KrBiQBgFMW8hijeGc2F17687YfZM63/JSvq1DN1hTQCfRa9AIJ79GM5YaaiM3JM
         1Gi3Pz/nqxrcpP+2Ps9LZYUBhVwF0j8yHO3F7K24ZF1nre39aY5Pg6X6JpX5H5VSJnqr
         EjlQfztoFiPZdBJL8jB6exf31ZJZg9kJ+/kE4=
Message-ID: <8265cb9e0806130405m340a314fm6935f388653e9e6a@mail.gmail.com>
Date: Fri, 13 Jun 2008 12:05:40 +0100
From: "Julia Jomantaite" <julia.jomantaite@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] drivers/acpi/video: fix brightness allocation
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       rui.zhang@intel.com
In-Reply-To: <20080612180006.7cc946b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8265cb9e0806120947o4f39f78aqa3ace61a1ec1d6e3@mail.gmail.com>
	 <20080612180006.7cc946b2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 2:00 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 12 Jun 2008 17:47:09 +0100
> "Julia Jomantaite" <julia.jomantaite@gmail.com> wrote:
>
>> ACPI Video Driver module (drivers/acpi/video.c) produces Oops message
>> after pressing one of two Fn+<key> combinations responsible for switching
>> the brightness level on my laptop.
>>
>> The source of this problem is in the function acpi_video_switch_brightness
>> which can access device->brightness when it is not allocated. Function
>> "acpi_video_device_find_cap" which is responsible for allocating
>> device->brightness can leave it unallocated in some cases.
>>
>> Function acpi_video_switch_brightness isn't called if modules's parameter
>> "brightness_switch_enabled" is equal to zero so i've decided to add
>> zeroing of this parameter to the part of the code where unsuccessfull
>> allocation of device->brightness was handled.
>>
>> Also i've moved initialization of brightness to a separate function
>> "acpi_video_init_brightness" to improve readability of the code and
>> to simplify error handling.
>>
>
> (cc's added)
>
> Thanks.  Which kernel version were you running?

This patch is for the latest version of kernel from git  (linux-2.6),
but the similar allocation problem exists on earlier versions of
kernel ( for example 2.6.22 and 2.6.23).

> The patch was a bit wordwrapped.  Here's the fixed up version:

Thank you.
