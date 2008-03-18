Return-Path: <linux-kernel-owner+w=401wt.eu-S939648AbYCSWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939648AbYCSWIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbYCSUdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:33:07 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:58966 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbYCSUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:33:04 -0400
Message-ID: <47DFE003.5040205@skyrush.com>
Date: Tue, 18 Mar 2008 09:30:11 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Interactivity degrades with CONFIG_[FAIR]_GROUP_SCHED set in
 2.6.24 and later
References: <47DE0BD7.7020500@skyrush.com>
In-Reply-To: <47DE0BD7.7020500@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Peterson wrote:
> When going from kernel 2.6.23 to 2.6.24, however, I noticed that
> interactivity (namely the smoothness of mouse motion) was noticeably
> less smooth under load.  The most obvious case was while pulling down a
> Subversion repository; the mouse would freeze for quite long periods
> while being moved (i.e. a large fraction of a second), which never
> happens under 2.6.23.  I was using ZFS-FUSE on the partition I was
> writing to, and it uses a lot of CPU at times, but 2.6.23 seems to
> handle it better.

I just made a couple of debug output files using the default
CONFIG_GROUP_SCHED setting in 2.6.25-rc5-git (from 3/16):

This one was done during a diff between two kernel source dirs:
http://www.skyrush.com/downloads/linux-cfs-debug/cfs-debug-info-2008.03.18-06.37.44

This one was done during an svn checkout:
http://www.skyrush.com/downloads/linux-cfs-debug/cfs-debug-info-2008.03.18-06.38.23

The latter one was done during a period exhibiting what felt like longer
and more profound pauses in mouse movement, however, the first debug
file shows several se.wait_max > 40.  Both cases showed very
choppy/jerky mouse movement with quite obvious freezes when moving the
mouse in circles during the tests.

Here is a snippet of the se.wait_max lines from the first file:

se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             7.375852
se.wait_max                        :             4.875690
se.wait_max                        :             7.211323
se.wait_max                        :             3.779489
se.wait_max                        :             2.770382
se.wait_max                        :            12.959876
se.wait_max                        :             3.524036
se.wait_max                        :            16.625484
se.wait_max                        :            73.991289
se.wait_max                        :            18.937293
se.wait_max                        :             6.955806
se.wait_max                        :            21.919110
se.wait_max                        :             6.922932
se.wait_max                        :            10.432544
se.wait_max                        :            76.222556
se.wait_max                        :             7.216472
se.wait_max                        :            90.987582
se.wait_max                        :             7.071110
se.wait_max                        :            16.332227
se.wait_max                        :             2.261235
se.wait_max                        :            67.892956
se.wait_max                        :            25.337064
se.wait_max                        :            44.180597
se.wait_max                        :            74.290628
se.wait_max                        :            12.631292
se.wait_max                        :             1.389533
se.wait_max                        :             3.653521
se.wait_max                        :             2.841697
se.wait_max                        :            16.234723
se.wait_max                        :           107.011747
se.wait_max                        :           110.638560
se.wait_max                        :             9.677538
se.wait_max                        :            15.852109
se.wait_max                        :            23.316106
se.wait_max                        :            18.428330
se.wait_max                        :            16.674552
se.wait_max                        :           110.630411
se.wait_max                        :            47.906824
se.wait_max                        :            74.191984
se.wait_max                        :            12.224021
se.wait_max                        :             2.184557
se.wait_max                        :            17.799343
se.wait_max                        :            17.670697
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000

I hope these help; please let me know if I can help further or run more
tests.

						-Thanks, Joe
