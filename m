Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbZAMOIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbZAMOIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbZAMOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:08:10 -0500
Received: from smtp.nokia.com ([192.100.122.233]:46886 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZAMOII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:08:08 -0500
Message-ID: <496CA304.9000802@nokia.com>
Date: Tue, 13 Jan 2009 16:19:48 +0200
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       "Lavinen Jarkko (Nokia-M/Helsinki)" <jarkko.lavinen@nokia.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: Re: [PATCH 2/2] OMAP: HSMMC: Fix response type for busy after response
References: <20090113133827.29474.92645.sendpatchset@ahunter-laptop>	<20090113133841.29474.15852.sendpatchset@ahunter-laptop> <20090113144952.3f8cbec8@mjolnir.drzeus.cx>
In-Reply-To: <20090113144952.3f8cbec8@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2009 14:07:35.0934 (UTC) FILETIME=[491BF1E0:01C97588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 13 Jan 2009 15:38:41 +0200
> Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:
> 
>> This also fixes the hidden problem that the controller
>> was turning off the clock to the card while the card
>> was busy - the clock was then switched on for the
>> duration of each Send Status command used for polling,
>> which is why writes did not lock up altogether.
>> i.e. really dysfunctional.
> 
> Does the driver only keep the clock running as long as there is an
> ongoing request? That kind of policy should really be handled in the
> core where we have more information and can control it better. E.g. some
> cards need the clock to finish up internal housekeeping so we need to
> delay things for those.
> 
> Rgds

Unfortunately it seems to be something the controller does by itself,
beyond the control of the driver.  Added Jarkko Lavinen and 
Madhusudhan Chikkature to CC, maybe they can correct me.

If it obeys the standard, it should give an additional 8 clock cycles.
