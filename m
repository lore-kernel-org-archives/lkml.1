Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYAWSEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYAWSEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYAWSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:04:13 -0500
Received: from mail0.scram.de ([78.47.204.202]:43384 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYAWSEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:04:12 -0500
X-Spam-Score: -4.225
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4797818F.2080603@scram.de>
Date: Wed, 23 Jan 2008 19:03:59 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCHv2 5/8] [POWERPC] Remove sysdev/commproc.h
References: <479764B8.4010909@scram.de> <83FEE161-D10D-4E21-BDB3-D0B6D49668CE@kernel.crashing.org>
In-Reply-To: <83FEE161-D10D-4E21-BDB3-D0B6D49668CE@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> Do we really need the prototypes you moved into asm/mpc8xx.h here?  can 
> they just live in platforms/8xx/8xx.h or something like that?

At least drivers/pcmcia/m8xx_pcmcia.c uses the symbol m8xx_pcmcia_ops
which is conditionally defined in platforms/8xx/m8xx_setup.c. However,
this driver currently seems to be broken (doesn't compile neither as
built-in nor as module).

Other drivers that include asm/mpc8xx.c are:

drivers/net/fec.c (the include seems to be obsolete, as according to Kconfig
                    the driver is only built on MPC52xx platforms)
drivers/net/fec_8xx (unused, depends on non-existant CONFIG_8XX)
drivers/net/fs_enet (i need to check if the include is needed, at all)

I'll have a closer look at this.

Thanks,
Jochen
