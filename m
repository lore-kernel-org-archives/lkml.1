Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbYFIWJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbYFIWJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbYFIWJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:09:35 -0400
Received: from web53708.mail.re2.yahoo.com ([206.190.37.29]:40185 "HELO
	web53708.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754427AbYFIWJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:09:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ugfpZTRhldzmuk72IIemOAPCol2Y/j5flY6nh1LtcQu7B5TUe/SEqY6T7xuwIkMMcOq18GVgzb7gE/O2fs4jeuK+9PVH1R4tvy+A1Phou6+6sztRJXtgmLj4TAU56wAIROfyeY8pLSbswy5rroXt0SPz+fkhryUgatogTAl8tvo=;
X-YMail-OSG: 1jUl7rUVM1lrdoeLrz63i8G80BOsns55lVRUzWNbIhvqW9beaM1r7s5czlHkAT0Aa4l8VE6lTX6zH9ddOvO582A48QSYksEWFrpLoJPYwtHkHJBXsXI9AkjGQO1msdeMl2ZJPIYYikt5MaqzTJEfYA--
Date: Mon, 9 Jun 2008 15:09:33 -0700 (PDT)
From: Benjamin Kidwell <benjkidwell@yahoo.com>
Subject: Re: Linux-next Alsa hda_intel events/0 high CPU usage, bisected
To: linux-kernel@vger.kernel.org
In-Reply-To: <s5hk5h1shys.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <364147.92870.qm@web53708.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Takashi Iwai <> wrote:
>Here is the patch to do another trick.
>The driver tries to delay the IRQ timing in one sample so that the DMA
>pointer returns the proper position.

I refer to the above patch as "patch #2" in discussing the tests below.

>Could you check the patch below in addition?  It's against my latest
>git tree and should be applicable as is to linux-next (since it merges
>from my tree), too.
>This will show some latency time in the kernel messages.  If the
>average latency is about 20 or 30us, this is almost in the expected
>range.  Occasional high latencies should be the result of
>cond_resched(), so it can be ignored.

Thanks very much for your time. Both patches applied to next-20080606. Patch
#2 to delay IRQ had 20/21 line offsets in hunks 4,5, and 6. I built kernels
with patch #1 only and with both patch #1 and #2. With reporting only (#1)
patch:
[   28.897483] hda-intel: Invalid position buffer, using LPIB read method
instead.
[   28.900819] XXX hda: max_delay=4535702 ns
[   29.344196] XXX hda: avg_delay=940 us
[   37.787584] XXX hda: max_delay=730886 ns
[   38.008854] XXX hda: max_delay=733118 ns
[   38.799034] XXX hda: max_delay=734487 ns
[   38.849953] XXX hda: avg_delay=721 us
[   38.958973] XXX hda: max_delay=728287 ns
[   40.269209] XXX hda: max_delay=2020331 ns
[   40.840784] XXX hda: max_delay=6639814 ns
[   46.543949] XXX hda: max_delay=8514464 ns
[   47.660992] XXX hda: avg_delay=905 us
[   55.677483] XXX hda: max_delay=721319 ns
[   55.701527] XXX hda: max_delay=722752 ns
[   56.515656] XXX hda: max_delay=724277 ns
[   56.762500] XXX hda: max_delay=729125 ns
[   58.147477] XXX hda: max_delay=3541590 ns
[   61.185499] XXX hda: max_delay=5094055 ns
[   68.174152] XXX hda: max_delay=7323778 ns
[  190.467470] XXX hda: max_delay=7446118 ns
[  205.747463] XXX hda: max_delay=8168689 ns
[  206.240797] XXX hda: max_delay=8587483 ns
[  252.643947] XXX hda: max_delay=9425211 ns

With BOTH patches applied:
[   29.988316] hda-intel: Invalid position buffer, using LPIB read method
instead.
[   29.991655] XXX hda: max_delay=4357840 ns
[   30.435030] XXX hda: avg_delay=603 us
[   36.211751] XXX hda: max_delay=374595 ns
[   36.534235] XXX hda: max_delay=1521772 ns
[   37.278175] XXX hda: avg_delay=404 us
[   37.384060] XXX hda: max_delay=366048 ns
[   37.408317] XXX hda: max_delay=372760 ns
[   37.583300] XXX hda: max_delay=2233243 ns
[   39.310484] XXX hda: max_delay=2369779 ns
[   39.367269] XXX hda: max_delay=9307321 ns
[   46.185005] XXX hda: avg_delay=502 us
[   66.041615] XXX hda: max_delay=367668 ns
[   66.065345] XXX hda: max_delay=372093 ns
[   67.521437] XXX hda: max_delay=373733 ns
[   68.656740] XXX hda: max_delay=373915 ns
[   71.574977] XXX hda: max_delay=4827092 ns
[  107.734975] XXX hda: max_delay=6589856 ns
[  111.288309] XXX hda: max_delay=6715648 ns
[  151.121642] XXX hda: max_delay=7695259 ns
[  220.478297] XXX hda: max_delay=9907063 ns
[  352.964963] XXX hda: max_delay=10756583 ns

With both patches in place, CPU% reported by ps for events/0 during sound
playback is substantially reduced. ps reports consistent 0.6% cpu instead of
2-3% or more. I notice that the avg_delay report is much higher than the
20-30us you say is the expected range.  It is lower with the second patch
applied, but still large.

Additional experimentation with various .config options had also shown that
options such as CONFIG_HZ also affect the reported CPU% and TIME from
events/0. Here's output from a kernel with both new patches applied and
configued with HZ=1000, and PREEMPT_RCU=y instead of 300 and
PREEMPT_VOLUNTARY.

[   29.550748] hda-intel: Invalid position buffer, using LPIB read method
instead.
[   29.553750] XXX hda: max_delay=3314411 ns
[   29.998764] XXX hda: avg_delay=519 us
[   31.406760] eth0: no IPv6 routers present
[   35.297443] XXX hda: max_delay=375157 ns
[   36.355211] XXX hda: avg_delay=147 us
[   36.595685] XXX hda: max_delay=367326 ns
[   36.620318] XXX hda: max_delay=373443 ns
[   37.041228] XXX hda: max_delay=1481064 ns
[   37.364519] XXX hda: max_delay=3983313 ns
[   41.265473] XXX hda: max_delay=5290882 ns
[   45.309086] XXX hda: avg_delay=437 us
[   80.042739] XXX hda: max_delay=367816 ns
[   80.067627] XXX hda: max_delay=370010 ns
[   80.955786] XXX hda: max_delay=389501 ns
[   82.881726] XXX hda: max_delay=1042298 ns
[   95.345744] XXX hda: max_delay=1144114 ns
[   95.397576] XXX hda: max_delay=3741325 ns
[  104.039739] XXX hda: max_delay=6832958 ns
[  137.435750] XXX hda: max_delay=9916982 ns

With this higher timer frequency and patch #2, ps reports avg. 1.2% events/0
usage vs. 2.3% with reporting patch #1 only. Here are timings from the same
.config but with only patch #1 (reporting) applied:

[   29.782022] hda-intel: Invalid position buffer, using LPIB read method
instead.
[   29.782708] XXX hda: max_delay=578709 ns
[   29.804012] XXX hda: max_delay=667540 ns
[   29.825934] XXX hda: max_delay=672530 ns
[   29.847229] XXX hda: max_delay=727943 ns
[   29.890260] XXX hda: max_delay=987514 ns
[   30.231269] XXX hda: avg_delay=677 us
[   30.254334] eth0: no IPv6 routers present
[   35.129783] XXX hda: max_delay=725808 ns
[   35.205719] XXX hda: max_delay=2394065 ns
[   36.181885] XXX hda: avg_delay=787 us
[   36.191131] XXX hda: max_delay=719683 ns
[   36.215970] XXX hda: max_delay=725257 ns
[   36.487256] XXX hda: max_delay=725928 ns
[   36.734025] XXX hda: max_delay=726886 ns
[   36.758713] XXX hda: max_delay=728874 ns
[   37.257252] XXX hda: max_delay=5298044 ns
[   43.330254] XXX hda: max_delay=6694653 ns
[   44.392286] XXX hda: max_delay=7673067 ns
[   44.892458] XXX hda: avg_delay=849 us
[   70.744252] XXX hda: max_delay=721293 ns
[   70.769134] XXX hda: max_delay=724172 ns
[   71.262857] XXX hda: max_delay=726017 ns
[   71.459987] XXX hda: max_delay=726454 ns
[   71.657588] XXX hda: max_delay=729122 ns
[   72.002882] XXX hda: max_delay=732543 ns
[   78.322253] XXX hda: max_delay=948022 ns
[   81.901253] XXX hda: max_delay=1121037 ns
[   81.951748] XXX hda: max_delay=2948531 ns
[   85.387252] XXX hda: max_delay=7308180 ns
[  101.678225] XXX hda: max_delay=8139181 ns
[  190.655620] XXX hda: max_delay=8721454 ns
[  315.991170] XXX hda: max_delay=10913594 ns
[  438.610252] XXX hda: max_delay=11273250 ns 

SUMMARY: the IRQ timing delay change patch (#2) produces improvement in all
test cases, reducing the avg_delay and events/0 CPU%. The avg_delay is still
outside expected values, but perhaps this is the best possible result given
the bugginess of the hardware. Audio quality and system performance are very
good in all tests.

Thanks again very much for your time and the test patches. Happy to provide
more info and testing if its useful to you.
Ben


      
