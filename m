Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYICOE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYICOE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYICOEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:04:20 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48484 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbYICOET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:04:19 -0400
From: Andrey Mirkin <major@openvz.org>
To: Louis.Rilling@kerlabs.com
Subject: Re: [PATCH 3/9] Introduce context structure needed during checkpointing/restart
Date: Wed, 3 Sep 2008 18:07:10 +0400
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1220439476-16465-4-git-send-email-major@openvz.org> <20080903135616.GR14473@hawkmoon.kerlabs.com>
In-Reply-To: <20080903135616.GR14473@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031807.11053.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 17:56 Louis Rilling wrote:
> On Wed, Sep 03, 2008 at 02:57:50PM +0400, Andrey Mirkin wrote:
> > Add functions for context allocation/destroy.
> > Introduce functions to read/write image.
> > Introduce image header and object header.
>
> [...]
>
> > diff --git a/cpt/cpt_image.h b/cpt/cpt_image.h
> > new file mode 100644
> > index 0000000..3d26229
> > --- /dev/null
> > +++ b/cpt/cpt_image.h
> > @@ -0,0 +1,63 @@
> > +/*
> > + *  Copyright (C) 2008 Parallels, Inc.
> > + *
> > + *  Author: Andrey Mirkin <major@openvz.org>
> > + *
> > + *  This program is free software; you can redistribute it and/or
> > + *  modify it under the terms of the GNU General Public License as
> > + *  published by the Free Software Foundation, version 2 of the
> > + *  License.
> > + *
> > + */
> > +
> > +#ifndef __CPT_IMAGE_H_
> > +#define __CPT_IMAGE_H_ 1
> > +
> > +enum _cpt_object_type
> > +{
> > +	CPT_OBJ_TASK = 0,
> > +	CPT_OBJ_MAX,
> > +	/* The objects above are stored in memory while checkpointing */
> > +
> > +	CPT_OBJ_HEAD = 1024,
> > +};
> > +
> > +enum _cpt_content_type {
> > +	CPT_CONTENT_VOID,
> > +	CPT_CONTENT_ARRAY,
> > +	CPT_CONTENT_DATA,
> > +	CPT_CONTENT_NAME,
> > +	CPT_CONTENT_REF,
> > +	CPT_CONTENT_MAX
> > +};
> > +
> > +#define CPT_SIGNATURE0 0x79
> > +#define CPT_SIGNATURE1 0x1c
> > +#define CPT_SIGNATURE2 0x01
> > +#define CPT_SIGNATURE3 0x63
> > +
> > +struct cpt_head
> > +{
> > +	__u8	cpt_signature[4];	/* Magic number */
> > +	__u32	cpt_hdrlen;		/* Header length */
> > +	__u16	cpt_image_major;	/* Format of this file */
> > +	__u16	cpt_image_minor;	/* Format of this file */
> > +	__u16	cpt_image_sublevel;	/* Format of this file */
> > +	__u16	cpt_image_extra;	/* Format of this file */
> > +	__u16	cpt_arch;		/* Architecture */
> > +	__u16	cpt_pad1;
> > +	__u32	cpt_pad2;
> > +#define CPT_ARCH_I386		0
>
> Why is this constant precisely defined after the padding?
I will move it right after cpt_arch. Thanks.

>
> > +	__u64	cpt_time;		/* Time */
> > +} __attribute__ ((aligned (8)));
> > +
> > +/* Common object header. */
> > +struct cpt_object_hdr
> > +{
> > +	__u64	cpt_len;		/* Size of current chunk of data */
> > +	__u16	cpt_type;		/* Type of object */
> > +	__u32	cpt_hdrlen;		/* Size of header */
> > +	__u16	cpt_content;		/* Content type: array, reference... */
>
> This layout looks a bit awkward for 32bits/64bits compatibility. Maybe put
> cpt_hdrlen before cpt_type?
You right here. Thanks for the catch. I will change that in next version.

Thanks,
Andrey
