Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbYA2MNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbYA2MNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYA2MNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:13:36 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:44359 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbYA2MNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:13:35 -0500
Message-ID: <479F186A.4020004@pengutronix.de>
Date: Tue, 29 Jan 2008 13:13:30 +0100
From: Luotao Fu <l.fu@pengutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU issue?
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com> <20080123145340.GE6200@pengutronix.de> <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de> <479DF711.5090406@grandegger.com>
In-Reply-To: <479DF711.5090406@grandegger.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Wolfgang Grandegger wrote:
..........
 > Do you still get high latencies with:
 >
 >   CONFIG_PREEMPT_RCU_BOOST=y
 >   CONFIG_RCU_TRACE=y
 >   CONFIG_NO_HZ is not set
 >
 > With this setting I have not yet realized latencies > 150us. Could you
 > please give it a try? If I change one of the parameters above, latency
 > increases in short time.

I played through some combination of the RCU options and can back your 
observation this time: With the rcu Tracer or the priority boost turned 
off I also could measure reliably extraordinory high latencies. If they 
are both turned on, no high latencies could be measured. Turning on the 
dynamic ticker however doesn't seem to cause high latencies during my 
test runs. Seemed like an rcu issue here.

Further such results only appear if the target board is booted with 
nfsrootfs. (As I already have mentioned several times before), which 
leads my suspection to rcu usage in nfs implementation. In this case 
this problem might even be platformindependent. I'd have to do some 
tests on one of our arm boards later to test this. Since there're no 
reports like this for other architecture as powerpc till now, I doubt 
quite if this is verifiable.

regards
Luotao Fu
-- 
    Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de

