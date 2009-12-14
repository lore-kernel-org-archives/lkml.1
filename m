Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZLNLb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZLNLb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZLNLb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:31:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50434 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750719AbZLNLb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:31:27 -0500
Date: Mon, 14 Dec 2009 11:31:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCH 1/1] twl4030-regulator: extend twlreg_info to contain
 turnon delay and remap
Message-ID: <20091214113125.GB21066@rakim.wolfsonmicro.main>
References: <1260518031-11192-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
 <20091211103537.GC18825@rakim.wolfsonmicro.main>
 <1260774317.31691.20.camel@keskisaa-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260774317.31691.20.camel@keskisaa-workstation>
X-Cookie: Too much is not enough.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:05:17AM +0200, Juha Keski-Saari wrote:

> has been turned on. The DM also quotes a maximum wakeup time for
> returning from sleep to full output, but that delay is much shorter. For
> some regulators the turnon delay is theoretically long enough for the
> reg_enable to return to the driver noticeably earlier than the regulator
> output is actually at target level.

OK.  This ramp rate thing is a general issue for regulators, especially
those that are controlled via GPIOs rather than I2C since for them the
control interface takes approximately zero time to respond.  Ideally we
want to do something slightly more involved than what you've got here
since if you're turning on more than one regulator at once it'd be nice
to be able to allow all the supplies to ramp in parallel rather than
serialising everything.

I've got a patch half done for this which I should try to finish off and
post soon but for now this should be OK.
