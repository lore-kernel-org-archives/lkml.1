Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787Ab0ARIOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0ARIOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226Ab0ARIOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:14:54 -0500
Received: from bamako.nerim.net ([62.4.17.28]:65030 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0ARIOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:14:53 -0500
Date: Mon, 18 Jan 2010 09:14:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, linux-kernel@vger.kernel.org,
       huaxu.wan@intel.com, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (coretemp) Fix TjMax for Atom 
 N450/D410/D510 CPUs
Message-ID: <20100118091451.7f103914@hyperion.delvare>
In-Reply-To: <20100118065821.GA19008@ywang-moblin2.bj.intel.com>
References: <20091224073102.GA23058@ywang-moblin2.bj.intel.com>
	<20100106160817.72313551@hyperion.delvare>
	<20100110200621.564a6682@hyperion.delvare>
	<20100111062024.GA20804@ywang-moblin2.bj.intel.com>
	<SNT125-W147C55AB6EB65D41CAAFFFC3680@phx.gbl>
	<20100117161518.4912be7c@hyperion.delvare>
	<4B536502.20102@gmail.com>
	<20100117210536.0ae0f187@hyperion.delvare>
	<20100118065821.GA19008@ywang-moblin2.bj.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 14:58:21 +0800, Yong Wang wrote:
> On Sun, Jan 17, 2010 at 09:05:36PM +0100, Jean Delvare wrote:
> > That's where I am confused. The patch checks for the presence of the
> > Intel NM10, which, reading its description looks much like a south
> > bridge and not a memory controller (north bridge). So I think the patch
> > is wrong (or at least incomplete).
> 
> Sorry, I made a mistake in the patch description. The new Atom CPU is
> coupled with integrated gfx and memory controller in one package. NM10
> chipset is another chip. This patch does check the presence of the
> integrated memory controller, i.e. 00:00.0 Host bridge device, which
> will always be present no matter whether NM10 chipset is used or not.

OK. Then indeed the patch description was rather bad. Even the comments
in the code are misleading, they mention the NM10 when they don't
really have to.

But at least if the code itself is OK... that's not that bad.

> > Anyway, how difficult would it be to set TjMax based on the CPUID? I
> > presume that the Intel Atom 400 and 500 series have their own CPUID
> > value, haven't they? This would seem even easier that checking for a
> > PCI device.
> 
> CPUID value (family and model number) remains the same for all Atom CPUs
> thus far. That is why we check the new Atom CPU this way.

What about the stepping value? Don't these CPU models have their own?

Thanks,
-- 
Jean Delvare
