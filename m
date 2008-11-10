Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYKJXoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYKJXoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYKJXoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:44:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbYKJXoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:44:06 -0500
Date: Mon, 10 Nov 2008 15:43:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: cbouatmailru@gmail.com, sameo@openedhand.com, linux-kernel@vger.kernel.org,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] power_supply: Add support for WM8350 PMU
Message-Id: <20081110154330.f95ec239.akpm@linux-foundation.org>
In-Reply-To: <1225984523-15911-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1225984523-15911-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2008 15:15:22 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> This patch adds support for the PMU provided by the WM8350 which
> implements battery, line and USB supplies including a battery charger.
> The hardware functions largely autonomously, with minimal software
> control required to initiate fast charging.
> 
> Support for configuration of the USB supply is not yet implemented.
> This means that the hardware will remain in the mode configured at
> startup, by default limiting the current drawn from USB to 100mA.
> 
> This driver was originally written by Liam Girdwood with subsequent
> updates for submission by Mark Brown.

An idle question...

> +		supply = "Battery";
> +		supply = "USB";
> +		supply = "Line";
> +		supply = "Battery and USB";

> +		charge = "Charger Off";
> +		charge = "Trickle Charging";
> +		charge = "Fast Charging";

> +		dev_err(wm8350->dev, "battery too hot\n");
> +		dev_err(wm8350->dev, "battery too cold\n");
> +		dev_err(wm8350->dev, "battery failed\n");
> +		dev_err(wm8350->dev, "charger timeout\n");
> +		dev_dbg(wm8350->dev, "charger stopped\n");
> +		dev_dbg(wm8350->dev, "charger started\n");
> +		dev_dbg(wm8350->dev, "fast charger ready\n");
> +		dev_warn(wm8350->dev, "battery < 3.9V\n");
> +		dev_warn(wm8350->dev, "battery < 3.1V\n");
> +		dev_warn(wm8350->dev, "battery < 2.85V\n");

The above constitutes a sort-of userspace interface.  A number of the
things which are being reported there are fairly common to the
technology and other drivers will be able to report them.

But afaict this interface is unique to this particular driver.  Has any
thought been given to standardising this interface across all similar
drivers?  Too messy?

