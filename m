Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYATKMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYATKMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 05:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYATKMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 05:12:07 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:3227 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbYATKMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 05:12:05 -0500
Date: Sun, 20 Jan 2008 11:11:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Adam Turk <bofh1234@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>, <i2c@lm-sensors.org>
Subject: Re: I2C_PARPORT_LIGHT dependence problem
Message-ID: <20080120111151.08b0266a@hyperion.delvare>
In-Reply-To: <BAY101-W29C4113A3B79204F64B0DCC8430@phx.gbl>
References: <BAY101-W29C4113A3B79204F64B0DCC8430@phx.gbl>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adam,

On Sat, 19 Jan 2008 13:37:05 -0500, Adam Turk wrote:
> I am updating an old config to run on 2.6.23.14 and noticed I am
> still prompted for I2C_PARPORT_LIGHT even though I don't have
> the parallel port driver enabled.  Shouldn't I2C_PARPORT_LIGHT
> depend on the parallel port being selected? (...)
> 
> Symbol: I2C_PARPORT_LIGHT [=n]
>   │ Prompt: Parallel port adapter (light)
>   │   Defined at drivers/i2c/busses/Kconfig:348
>   │   Depends on: I2C
>   │   Location:
>   │     -> Device Drivers
>   │       -> I2C support (I2C [=m])
>   │         -> I2C Hardware Bus support
>   │   Selects: I2C_ALGOBIT

The help text says:

"This driver is a light version of i2c-parport.  It doesn't depend on
the parport driver, and uses direct I/O access instead."

So I think that the (lack of) dependencies is correct. We don't want to
force the user to select PARPORT (and built the parport driver) to get
access to the i2c-parport-light driver which does NOT need this parport
driver.

-- 
Jean Delvare
