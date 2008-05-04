Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbYEDWhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbYEDWhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYEDWhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:37:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64560 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYEDWhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:37:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 47/56] microblaze_v2: device.h param.h topology.h
Date: Mon, 5 May 2008 00:37:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu> <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>
In-Reply-To: <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050037.24534.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+l2QGsqzB/LJEb9XMGEta0+z/3YgFGGhnd92y
 UZPXvAZWnQ8cr+HDE+2x+LhVV57gqkPbBkcU5Nrm62SoSyerwQ
 Mqf7zpoGXxNqwk/u7C33g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:

> +#ifndef _ASM_MICROBLAZE_DEVICE_H
> +#define _ASM_MICROBLAZE_DEVICE_H
> +
> +struct dma_mapping_ops;
> +struct device_node;
> +
> +struct dev_archdata {
> +	/* Optional pointer to an OF device node */
> +	struct device_node	*of_node;
> +
> +	/* DMA operations on that device */
> +	struct dma_mapping_ops	*dma_ops;
> +	void			*dma_data;
> +
> +	/* NUMA node if applicable */
> +	int			numa_node;
> +};

microblaze doesn't have NUMA or dma_mapping_ops, afaict, so it should
just be

struct dev_archdata {
	/* Optional pointer to an OF device node */
	struct device_node	*of_node;
};

> --- /dev/null
> +++ b/include/asm-microblaze/param.h
> @@ -0,0 +1,36 @@
> +/*
> + * include/asm-microblaze/param.h
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License. See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2006 Atmark Techno, Inc.
> + */
> +
> +#ifndef _ASM_MICROBLAZE_PARAM_H
> +#define _ASM_MICROBLAZE_PARAM_H
> +
> +#ifdef __KERNEL__
> +# define HZ		100 /* internal timer frequency */
> +# define USER_HZ	100 /* for user interfaces in "ticks" */
> +# define CLOCKS_PER_SEC (USER_HZ) /* frequnzy at which times() counts */
> +#endif
> +
> +#ifndef NGROUPS
> +#define NGROUPS		32
> +#endif
> +
> +#ifndef NOGROUP
> +#define NOGROUP		(-1)
> +#endif
> +
> +#define EXEC_PAGESIZE	4096
> +
> +#ifndef HZ
> +#define HZ 100
> +#endif
> +
> +#define MAXHOSTNAMELEN	64 /* max length of hostname */
> +
> +#endif /* _ASM_MICROBLAZE_PARAM_H */

These parameters are so common that they should become asm-generic/param.h.
4kb page size is of course a HW feature, but it's so universal that it's almost
a natural constant ;-)

> --- /dev/null
> +++ b/include/asm-microblaze/topology.h
> @@ -0,0 +1,119 @@
> +/*
> + * include/asm-microblaze/topology.h

please use the existing asm-generic/topology.h here.

	Arnd <><
