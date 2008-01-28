Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbYA1PLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbYA1PLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYA1PLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:11:34 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:56831 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbYA1PLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:11:33 -0500
Message-ID: <479DF0A1.3000906@pengutronix.de>
Date: Mon, 28 Jan 2008 16:11:29 +0100
From: Luotao Fu <l.fu@pengutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com> <20080123145340.GE6200@pengutronix.de> <47976D06.1010900@grandegger.com>
In-Reply-To: <47976D06.1010900@grandegger.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 10.1.0.69
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I took some time today and went through Wolfgangs scenarios partly. Now 
some results from my side. I ran my tests on a 2.6.24-rt1

Wolfgang Grandegger wrote:
  > I also did some more measurements and made, by chance, interesting
> observations. I will summarize in more detail later on. Here are some
> preliminary results. My high latencies of up to 570us (without latency
> tracer) seem to be caused mainly by the following setting:
> 
>   CONFIG_RCU_TRACE=m
> 

I also got high latencies without CONFIG_RCU_TRACE set at all. setting 
CONFIG_RCU_TRACE to y or m causes also high latency though in my test 
runs. Hence I doubt the rcu Tracer is really the problem.

As I mentioned in my last mail. Only thing I could reproduce reliably is 
that the measurement results depend heavily on kind of the non-rt 
Workload. For with hackbench or cache calibrator I couldn't produce 
abnormal high latencies. Nor could I produce the hight latencies on a 
system booted via flash. Hence my suspects stays on the fec irq thread 
and filesystem access routines.

> With CONFIG_NO_HZ=y or CONFIG_PPC_BESTCOMM_GEN_BD=y the latency
> increases by approx. 100..150us, each.
> 

Since I was producing high latencies independently from the rcu 
settings. I didn't spend a lot of time playing around with the GEN_BD 
and dynamic clock. All I can say is that disabling them also cause high 
latency. ;-) The average results don't differ significantly in my test runs.

cheers
Luotao Fu
-- 
    Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-3
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de

