Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbYEEOGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbYEEOGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYEEOGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:06:46 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:58184 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753545AbYEEOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:06:45 -0400
Message-ID: <481F14AF.7000000@seznam.cz>
Date: Mon, 05 May 2008 16:07:43 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 47/56] microblaze_v2: device.h param.h topology.h
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu> <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu> <200805050037.24534.arnd@arndb.de>
In-Reply-To: <200805050037.24534.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reduced device.h. Remove NUMA from structure and comment NUMA in OF files.
param.h moved to generic folder.

M

>> +#ifndef _ASM_MICROBLAZE_DEVICE_H
>> +#define _ASM_MICROBLAZE_DEVICE_H
>> +
>> +struct dma_mapping_ops;
>> +struct device_node;
>> +
>> +struct dev_archdata {
>> +	/* Optional pointer to an OF device node */
>> +	struct device_node	*of_node;
>> +
>> +	/* DMA operations on that device */
>> +	struct dma_mapping_ops	*dma_ops;
>> +	void			*dma_data;
>> +
>> +	/* NUMA node if applicable */
>> +	int			numa_node;
>> +};
> 
> microblaze doesn't have NUMA or dma_mapping_ops, afaict, so it should
> just be
> 
> struct dev_archdata {
> 	/* Optional pointer to an OF device node */
> 	struct device_node	*of_node;
> };
> 
>> --- /dev/null
>> +++ b/include/asm-microblaze/param.h
>> @@ -0,0 +1,36 @@
>> +/*
>> + * include/asm-microblaze/param.h
>> + *
>> + * This file is subject to the terms and conditions of the GNU General Public
>> + * License. See the file "COPYING" in the main directory of this archive
>> + * for more details.
>> + *
>> + * Copyright (C) 2006 Atmark Techno, Inc.
>> + */
>> +
>> +#ifndef _ASM_MICROBLAZE_PARAM_H
>> +#define _ASM_MICROBLAZE_PARAM_H
>> +
>> +#ifdef __KERNEL__
>> +# define HZ		100 /* internal timer frequency */
>> +# define USER_HZ	100 /* for user interfaces in "ticks" */
>> +# define CLOCKS_PER_SEC (USER_HZ) /* frequnzy at which times() counts */
>> +#endif
>> +
>> +#ifndef NGROUPS
>> +#define NGROUPS		32
>> +#endif
>> +
>> +#ifndef NOGROUP
>> +#define NOGROUP		(-1)
>> +#endif
>> +
>> +#define EXEC_PAGESIZE	4096
>> +
>> +#ifndef HZ
>> +#define HZ 100
>> +#endif
>> +
>> +#define MAXHOSTNAMELEN	64 /* max length of hostname */
>> +
>> +#endif /* _ASM_MICROBLAZE_PARAM_H */
> 
> These parameters are so common that they should become asm-generic/param.h.
> 4kb page size is of course a HW feature, but it's so universal that it's almost
> a natural constant ;-)
> 
>> --- /dev/null
>> +++ b/include/asm-microblaze/topology.h
>> @@ -0,0 +1,119 @@
>> +/*
>> + * include/asm-microblaze/topology.h
> 
> please use the existing asm-generic/topology.h here.
> 
> 	Arnd <><
> 
> 
