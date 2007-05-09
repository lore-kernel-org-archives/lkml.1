Return-Path: <linux-kernel-owner+w=401wt.eu-S1760537AbXEIXyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbXEIXyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbXEIXxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:53:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbXEIXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:53:53 -0400
Date: Wed, 9 May 2007 16:53:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Samuel Ortiz <samuel@sortiz.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] 8xx: PQ SoC IRDA support
Message-Id: <20070509165317.fcf7dbf5.akpm@linux-foundation.org>
In-Reply-To: <20070508224206.4039.87074.stgit@localhost.localdomain>
References: <20070508224206.4039.87074.stgit@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 02:42:07 +0400
Vitaly Bordug <vitb@kernel.crashing.org> wrote:

> +		model = (char *)get_property(np, "model", NULL);
> +		if (model == NULL)
> +			return -ENODEV;
> +
> +		id = (u32 *) get_property(np, "device-id", NULL);

get_property() got renamed to of_get_property().

You have two coding-styles in the typecasting here.  The former (no space)
is more common and makes more sense, IMO.

However of_get_property() returns const void* so really you shouldn't be
doing any casting at all.  `model' should have type `const char *' and then
you can do

	model = get_property(np, "model", NULL);

which has nice type-safety and const-correctness.

