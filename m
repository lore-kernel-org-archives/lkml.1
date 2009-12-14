Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZLNHGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZLNHGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 02:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZLNHGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 02:06:00 -0500
Received: from smtp.nokia.com ([192.100.122.233]:61316 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZLNHF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 02:05:59 -0500
Subject: Re: [PATCH 1/1] twl4030-regulator: extend twlreg_info to contain
 turnon delay and remap
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
In-Reply-To: <20091211103537.GC18825@rakim.wolfsonmicro.main>
References: <1260518031-11192-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
	 <20091211103537.GC18825@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 09:05:17 +0200
Message-ID: <1260774317.31691.20.camel@keskisaa-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2009 07:05:23.0010 (UTC) FILETIME=[CDE4C220:01CA7C8B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 11:35 +0100, ext Mark Brown wrote:
> On Fri, Dec 11, 2009 at 09:53:51AM +0200, Juha Keski-Saari wrote:
> > Extend the twlreg_info structure to hold the turnon delay and remap config
> > value for regulators, and implement turnon delay in reg_enable
> 
> Hrm, what exactly are these parameters?  Are they for inital power
> sequencing or runtime things?
> 
> but for the default setting this does
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

The remap configuration is as before, just put in a nicer form to group
the values better with the regulator definitions, restoring the REMAP
configuration was intended as an initial step after bootloader to make
sure we know the configuration.

The turnon delay values are quoted by the TWL4030 Data manual as the
maximum time it may take for the regulator to reach full output after it
has been turned on. The DM also quotes a maximum wakeup time for
returning from sleep to full output, but that delay is much shorter. For
some regulators the turnon delay is theoretically long enough for the
reg_enable to return to the driver noticeably earlier than the regulator
output is actually at target level.

