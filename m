Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYBVQN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYBVQN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYBVQNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:13:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51178 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756441AbYBVQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:13:05 -0500
Subject: Re: [UPDATED v2][PATCH 0/6] regulator: voltage and current
	regulator framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: eric miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <f17812d70802211922v49201af2re87629eba34bd9d4@mail.gmail.com>
References: <1203527326.4071.88.camel@localhost.localdomain>
	 <20080221084128.GA4931@flint.arm.linux.org.uk>
	 <1203611191.4071.186.camel@localhost.localdomain>
	 <f17812d70802211922v49201af2re87629eba34bd9d4@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 12:36:30 +0000
Message-Id: <1203683790.4071.262.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 11:22 +0800, eric miao wrote:
> 
> I have a rough peek into the git tree on opensource.wolfsonmicro.com,
> find another PMIC framework, and here instead is a regulator framework,
> looks like a simplified or dedicated one. What is their relationship?
> 

This is probably the old version you came across. It was tightly coupled
to a particular PMIC and SoC CPU and not portable. The new version that
I posted is portable and not tied to a particular PMIC or CPU
architecture. The new version is hosted in the audioplus git repository
(imx31 branch).

> For those PMIC that covers additional features, like
>   - usb vbus detection (or pull-up/pull-down)
>   - audio codec
>   - touch screen
>   - battery monitor/ fuel gauge
>   - battery charger
>   - possible many others
> 
> How do you plan to handle them?

The WM8350 and MC13783 are both multi feature PMIC's like above. We
handle WM8350 PMIC access via a bus manager. This controls IO access to
the WM8350 so that client driver (including the regulator driver) IO
does not collide. We also cache non volatile PMIC registers to speed up
access. Please have a look at drivers/regulator/wm8350/wm8350-bus.c in
the imx31 branch for details.

Liam




