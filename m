Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYA1PjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYA1PjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYA1PjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:39:03 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57986 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYA1PjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:39:00 -0500
X-Auth-Info: JX+F+luKo/tX+LkUjqNebg7mVzIcXC7B1ePCb624ghg=
X-Auth-Info: JX+F+luKo/tX+LkUjqNebg7mVzIcXC7B1ePCb624ghg=
X-Auth-Info: JX+F+luKo/tX+LkUjqNebg7mVzIcXC7B1ePCb624ghg=
X-Auth-Info: JX+F+luKo/tX+LkUjqNebg7mVzIcXC7B1ePCb624ghg=
X-Auth-Info: JX+F+luKo/tX+LkUjqNebg7mVzIcXC7B1ePCb624ghg=
X-Auth-Info: JX+F+luKo/tX+LkUjqNebg7mVzIcXC7B1ePCb624ghg=
Message-ID: <479DF711.5090406@grandegger.com>
Date: Mon, 28 Jan 2008 16:38:57 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Luotao Fu <l.fu@pengutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc
References: <1200544050.318.18.camel@localhost.localdomain> <478F2A46.5070506@grandegger.com> <20080123145340.GE6200@pengutronix.de> <47976D06.1010900@grandegger.com> <479DF0A1.3000906@pengutronix.de>
In-Reply-To: <479DF0A1.3000906@pengutronix.de>
X-Enigmail-Version: 0.94.4.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fu,

Luotao Fu wrote:
> Hi,
> 
> I took some time today and went through Wolfgangs scenarios partly. Now
> some results from my side. I ran my tests on a 2.6.24-rt1
> 
> Wolfgang Grandegger wrote:
>  > I also did some more measurements and made, by chance, interesting
>> observations. I will summarize in more detail later on. Here are some
>> preliminary results. My high latencies of up to 570us (without latency
>> tracer) seem to be caused mainly by the following setting:
>>
>>   CONFIG_RCU_TRACE=m
>>
> 
> I also got high latencies without CONFIG_RCU_TRACE set at all. setting
> CONFIG_RCU_TRACE to y or m causes also high latency though in my test
> runs. Hence I doubt the rcu Tracer is really the problem.
> 
> As I mentioned in my last mail. Only thing I could reproduce reliably is
> that the measurement results depend heavily on kind of the non-rt
> Workload. For with hackbench or cache calibrator I couldn't produce
> abnormal high latencies. Nor could I produce the hight latencies on a
> system booted via flash. Hence my suspects stays on the fec irq thread
> and filesystem access routines.
> 
>> With CONFIG_NO_HZ=y or CONFIG_PPC_BESTCOMM_GEN_BD=y the latency
>> increases by approx. 100..150us, each.
>>
> 
> Since I was producing high latencies independently from the rcu
> settings. I didn't spend a lot of time playing around with the GEN_BD
> and dynamic clock. All I can say is that disabling them also cause high
> latency. ;-) The average results don't differ significantly in my test
> runs.

In the meantime I have measured the impact more carefully and posted the
results to the list:

- CONFIG_RCU_TRACE or CONFIG_PREEMPT_RCU_BOOST not set causes high
  latencies up to 500..600us.

- CONFIG_NO_HZ=y increases the latency by 90 us, at least.

- CONFIG_PPC_BESTCOMM_GEN_BD=y seems not to harm.

Do you still get high latencies with:

  CONFIG_PREEMPT_RCU_BOOST=y
  CONFIG_RCU_TRACE=y
  CONFIG_NO_HZ is not set

With this setting I have not yet realized latencies > 150us. Could you
please give it a try? If I change one of the parameters above, latency
increases in short time.

Thanks.

Wolfgang.


