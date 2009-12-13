Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZLMT4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZLMT4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZLMT4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:56:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38594 "HELO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754046AbZLMT4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:56:12 -0500
Date: Sun, 13 Dec 2009 20:56:07 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mfd: mc13783: Take care of semantic inversion
	between read and write value of two bits in POWER_MISCELLANEUS
	register.
Message-ID: <20091213195606.GA14024@pengutronix.de>
References: <1260635829.2054.16.camel@climbing-alby> <1260636523.2054.28.camel@climbing-alby>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1260636523.2054.28.camel@climbing-alby>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 05:48:43PM +0100, Alberto Panizzo wrote:
> MC13783_REGCTRL_PWGTnSPIEN controls the states of the corresponding
> PWGTn_DRV output.
> Reading 1 on the corresponding bit mean that the output is enabled
> Writing 1 on the corresponding bit disable that output!
> 
> So, if not asked directly to modify those bits, write the inverted
> value.
Hmm, I'm not sure this completely right.  The Spec has:

        Bit PWGTxSPIEN | Pin PWGTxEN | PWGTxDRV |  Read Back
          0 = default  |             |          | PWGTxSPIEN
        ---------------+-------------+----------+------------
              1        |      x      |   Low    |     0
              0        |      0      |   High   |     1
              0        |      1      |   Low    |     0

So it looks a bit harder than just inverting the read bit.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
