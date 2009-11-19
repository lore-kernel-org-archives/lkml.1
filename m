Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZKSHEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZKSHEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 02:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZKSHEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 02:04:39 -0500
Received: from smtp.nokia.com ([192.100.122.230]:60142 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZKSHEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 02:04:39 -0500
Message-ID: <4B04EDE8.1010906@nokia.com>
Date: Thu, 19 Nov 2009 09:04:08 +0200
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
       "sameo@linux.intel.com" <sameo@linux.intel.com>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "tony@atomide.com" <tony@atomide.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>,
       "amit.kucheria@verdurent.com" <amit.kucheria@verdurent.com>,
       "dtor@mail.ru" <dtor@mail.ru>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Kristo Tero (Nokia-D/Tampere)" <Tero.Kristo@nokia.com>
Subject: Re: [PATCH 1/1] Add all TWL4030 regulators to Regulator framework
References: <4B03DE53.6010007@nokia.com> <4B03DE9B.40800@nokia.com> <20091118133938.GE6592@rakim.wolfsonmicro.main> <20091118143609.GD2832@esdhcp037198.research.nokia.com> <20091118144145.GA16852@rakim.wolfsonmicro.main>
In-Reply-To: <20091118144145.GA16852@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2009 07:04:15.0388 (UTC) FILETIME=[8142B5C0:01CA68E6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Mark Brown wrote:
> On Wed, Nov 18, 2009 at 04:36:09PM +0200, Eduardo Valentin wrote:
> 
>> But maybe these VINT* should be set as always_on in twl4030-regulator driver?
> 
> Can they support any external load at all?  If not then it would make
> sense for the chip driver to at least provide a default set of
> constraints for them rather than forcing all the machine drivers to do
> it manually.

 From the TRM it appears that the max current output values are as follows

VINTANA1 - 30mA
VINTANA2 - 250mA
VINTDIG  - 100mA

Theoretically they may be able to support external load depending on your machine configuration but still I think providing constraints for them in 
the chip driver could be a good idea since the "always-on" limitation is imposed by the chip and not the machine. Without these three supplies the TWL 
does not function properly, if at all. Also worth noting is that the current implementation of RegulatorFW doesn't appear to be able to turn these 
supplies off (comparing TWL register content with framework status).
