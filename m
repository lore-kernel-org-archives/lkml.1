Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbZJMSG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbZJMSG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760600AbZJMSG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:06:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362AbZJMSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:06:26 -0400
Date: Tue, 13 Oct 2009 11:05:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] GPIO: Add gpio_lookup
Message-Id: <20091013110507.a576310a.akpm@linux-foundation.org>
In-Reply-To: <20091010134814.0bac8624@bike.lwn.net>
References: <20091010134814.0bac8624@bike.lwn.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 13:48:14 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> +int gpio_lookup(const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARCH_NR_GPIOS; i++) {
> +		struct gpio_chip *chip = gpio_desc[i].chip;
> +
> +		if (chip == NULL || chip->names == NULL)
> +			continue;
> +		if (!strcmp (name, chip->names[i - chip->base])) {
> +			printk(KERN_NOTICE "grbn found %d\n", i);
> +			return i;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(gpio_lookup);

I'll assume the printk wasn't supposed to be there.
