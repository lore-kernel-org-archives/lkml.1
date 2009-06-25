Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZFYNMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZFYNMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZFYNLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:11:53 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:38066 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbZFYNLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:11:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A437792.6040009@gmail.com>
Date: Thu, 25 Jun 2009 13:11:46 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH] regulator: Allow consumer supplies to be set up with
 dev_name()
References: <1245257799-29752-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1245257799-29752-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> Follow the approach suggested by Russell King and implemented by him in
> the clkdev API and allow consumer device supply mapings to be set up
> using the dev_name() for the consumer instead of the struct device.
> In order to avoid making existing machines instabuggy and creating merge
> issues the use of struct device is still supported for the time being.
>
> This resolves problems working with buses such as I2C which make the
> struct device available late providing that the final device name is
> known, which is the case for most embedded systems with fixed setups.
>
> Consumers must still use the struct device when calling regulator_get().
>
>   
Hi,

This patch is an excellent solution to the problem.

I just wonder if we need to suggest subsystem maintainers make sure that
their
device names are suitably unique and identifiable?  For example, i2c device
tend to have names like 0-0032.  Perhaps we need something to identify
that they
are indeed i2c devices?

For that matter, is there anything other than blind luck preventing two
regulator
consumers having the same dev_name?

---
Jonathan Cameron



