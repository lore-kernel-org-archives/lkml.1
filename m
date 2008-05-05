Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbYEEEYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbYEEEYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYEEEYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:24:42 -0400
Received: from ozlabs.org ([203.10.76.45]:44982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbYEEEYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:24:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18462.35282.374180.770237@cargo.ozlabs.ibm.com>
Date: Mon, 5 May 2008 14:15:14 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Kumar Gala <galak@kernel.crashing.org>, Jean Delvare <khali@linux-fr.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       David Miller <davem@davemloft.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] [POWERPC] Fix of_i2c include for module compilation
In-Reply-To: <481C5DD0.5090503@scram.de>
References: <481C5DD0.5090503@scram.de>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich writes:

> -#ifdef CONFIG_OF_I2C
> +#if defined(CONFIG_OF_I2C) || defined(CONFIG_OF_I2C_MODULE)
>  
>  void of_register_i2c_devices(struct i2c_adapter *adap,
>  			     struct device_node *adap_node);

Why do we have that ifdef there at all?  There's only that one
external declaration within it, so the #ifdef and #endif could just be
removed.  If the ifdef hadn't been there in the first place we
wouldn't have had this problem.

Paul.
