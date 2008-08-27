Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYH0Fn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYH0Fn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 01:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYH0Fnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 01:43:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:30738 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYH0Fnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 01:43:47 -0400
Subject: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Bruce Leonard <brucle@earthlink.net>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <48AB3AAF.3010504@earthlink.net>
References: <48AB3AAF.3010504@earthlink.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 27 Aug 2008 08:40:17 +0300
Message-Id: <1219815617.18027.132.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Aug 2008 05:43:29.0469 (UTC) FILETIME=[D56466D0:01C90807]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce,

On Tue, 2008-08-19 at 14:27 -0700, Bruce Leonard wrote:
> +/*
> + * Inline function for determining the size of the MTD device, independant
> + * of old or new way of doing things.
> + *
> + */
> +static inline u_int64_t device_size(struct mtd_info *a)
> +{
> +	return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks * a->erasesize;
> +}

I do not think it is a good idea to do multiplication every time we need
MTD device size. It is unnecessarily large overhead in terms of speed
and code size.

Did you consider a possibility of just making mtd->size 64 bit?
Or using eraseblock:offset pairs instead of absolute address?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

