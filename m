Return-Path: <linux-kernel-owner+w=401wt.eu-S936623AbYBWI1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936623AbYBWI1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbYBWIKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:10:07 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465AbYBWIKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:10:05 -0500
Date: Sat, 23 Feb 2008 00:05:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/6] regulator: platform level interface.
Message-Id: <20080223000535.ca36d562.akpm@linux-foundation.org>
In-Reply-To: <1203527345.4071.91.camel@localhost.localdomain>
References: <1203527345.4071.91.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 17:09:05 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This interface configures a regulator for use within a specific device. It
> allows for the creation of voltage and current domains (with constraints) for
> each regulator. Regulator constraints help prevent device damage by providing
> protection for over voltage or over current events caused by buggy client
> drivers.
> 
> This interface also allows the creation of a regulator tree whereby some
> regulators are supplied by others (similar to a clock tree). This means a
> parent regulator will be enabled before it's children are enabled and
> disabled after it's children have all been disabled.
> 
> ...
>
> +/**
> + * struct regulation_constraints - regulator operating constraints.
> + *
> + * This struct describes regulator and board/machine specific constraints.
> + */
> +struct regulation_constraints {
> +
> +	char *name;
> +
> +	/* voltage output range - for voltage control */
> +	int min_uV;
> +	int max_uV;
> +
> +	/* current output range - for current control */
> +	int min_uA;
> +	int max_uA;

It might be worth mentioning whether these are inclusive or exclusive limits.

> +	/* valid regulator operating modes for this machine */
> +	unsigned int valid_modes_mask;
> +
> +	/* valid operations for regulator on this machine */
> +	unsigned int valid_ops_mask;
> +
> +	/* input voltage */
> +	int input_uV;
> +};
> +

