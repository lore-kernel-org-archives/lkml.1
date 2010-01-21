Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617Ab0AUN4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0AUN4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189Ab0AUN4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:56:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51584 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0AUN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:56:39 -0500
Subject: Re: [PATCH v2] regulator: mc13783: consider Power Gates as digital
 regulators.
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <1263901734.6669.28.camel@realization>
References: <1263901734.6669.28.camel@realization>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 13:56:35 +0000
Message-ID: <1264082195.2396.137.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 12:48 +0100, Alberto Panizzo wrote:
> GPO regulators are digital outputs that can be enabled or disabled by a
> dedicated bit in mc13783 POWERMISC register.
> In this family can be count in also Power Gates (PWGT1 and 2): enabled by
> a dedicated pin a Power Gate is an hardware driven supply where the output
> (PWGTnDRV) follow this law:
> 
>  Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
>    0 = default  |             |          | PWGTxSPIEN
>  ---------------+-------------+----------+------------
>        1        |      x      |   Low    |     0
>        0        |      0      |   High   |     1
>        0        |      1      |   Low    |     0
> 
> As read back value of control bit reflects the PWGTxDRV state (not the
> control value previously written) and mc13783 POWERMISC register contain
> only regulator related bits, a dedicated function to manage these bits is 
> created here with the aim of tracing the real value of PWGTxSPIEN bits
> and reproduce it on next writes.
> 
> All POWERMISC users _must_ use the new function to not accidentally
> disable Power Gates supplies.
> 
> v2 changes:
> -Better utilization of abstraction layers.
> -Voltage query support. GPO's and PWGTxDRV are fixed voltage regulator
>  with voltage value of 3.1V and 5.5V respectively.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Applied.

Thanks

Liam

