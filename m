Return-Path: <linux-kernel-owner+w=401wt.eu-S937111AbYBWIXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937111AbYBWIXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765818AbYBWIJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:36 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763904AbYBWIJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:24 -0500
Date: Sat, 23 Feb 2008 00:05:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 2/6] regulator: regulator driver interface.
Message-Id: <20080223000532.a0eb106f.akpm@linux-foundation.org>
In-Reply-To: <1203527341.4071.90.camel@localhost.localdomain>
References: <1203527341.4071.90.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 17:09:00 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This interface allows regulator drivers to register their voltage and current
> regulators with the core. It also has a notifier call chain for propagating
> regulator events to clients.
> 
> +
> +/**
> + * struct regulator_ops - regulator operations.
> + *
> + * This struct describes regulator operations.
> + */

You can actually document the struct's fields in the kerneldoc comment
here, although I tend to think that it's better to document them as you
have done - ther eis more room, and people are more likely to remember to
update the comments when adding/removing/modifying fields.

> +struct regulator_ops {
> +
> +	/* get/set regulator voltage */
> +	int (*set_voltage)(struct regulator_cdev *, int uV);
> +	int (*get_voltage)(struct regulator_cdev *);
> +
> +	/* get/set regulator current  */
> +	int (*set_current)(struct regulator_cdev *, int uA);
> +	int (*get_current)(struct regulator_cdev *);
> +
> +	/* enable/disable regulator */
> +	int (*enable)(struct regulator_cdev *);
> +	int (*disable)(struct regulator_cdev *);
> +	int (*is_enabled)(struct regulator_cdev *);
> +
> +	/* get/set regulator operating mode (defined in regulator.h) */
> +	int (*set_mode)(struct regulator_cdev *, unsigned int mode);
> +	unsigned int (*get_mode)(struct regulator_cdev *);
> +
> +	/* get most efficient regulator operating mode for load */
> +	unsigned int (*get_optimum_mode)(struct regulator_cdev *, int input_uV,
> +		int output_uV, int load_uA);
> +};
>
> ...
>
> +/**
> + * regulator_get_drvdata - get regulator driver data
> + * @regulator: regulator
> + */
> +void *rcdev_get_drvdata (struct regulator_cdev *rcdev);
> +
> +/**
> + * regulator_get_id - get regulator ID
> + * @regulator: regulator
> + */
> +int rcdev_get_id (struct regulator_cdev *rcdev);

Please use scripts/checkpatch.pl...
