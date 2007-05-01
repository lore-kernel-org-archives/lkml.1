Return-Path: <linux-kernel-owner+w=401wt.eu-S1423665AbXEAVVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423665AbXEAVVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423661AbXEAVVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:21:21 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:42098 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423665AbXEAVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:21:20 -0400
Date: Tue, 1 May 2007 14:21:19 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Simon Arlott <simon@fire.lp0.eu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] dvb-core: Handle failures to create devices
In-Reply-To: <463774FE.9030104@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.58.0705011418130.309@shell2.speakeasy.net>
References: <463774FE.9030104@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Simon Arlott wrote:
> dvb-core is not started early enough when device drivers that use dvb are
> compiled in so device_register_device fails (silently) since dvb_class is
> NULL, this runs dvb_init using subsys_initclass instead of module_init.
>
> dvb_register_device will now check the return value of class_device_create.

Good catch.

> +		printk("%s: failed to create device dvb%d.%s%d (%ld)\n", __FUNCTION__,
> +			adap->num, dnames[type], id, PTR_ERR(clsdev));
> +		return PTR_ERR(clsdev);

printk(KERN_ERR "...."

