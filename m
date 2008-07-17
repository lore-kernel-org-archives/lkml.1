Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYGQHKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYGQHKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYGQHJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:09:58 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21856 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbYGQHJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:09:57 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5340"; a="4617967"
Message-ID: <487EF03D.9090401@qualcomm.com>
Date: Thu, 17 Jul 2008 00:09:49 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v4
References: <487B05CE.1050508@jp.fujitsu.com> <487EE2DB.7090205@jp.fujitsu.com>
In-Reply-To: <487EE2DB.7090205@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> If stop_machine() invoked while one of onlined cpu is locked up
> by some reason, stop_machine cannot finish its work because the
> locked cpu cannot stop.  This means all other healthy cpus
> will be blocked infinitely by one dead cpu.
> 
> This patch allows stop_machine to return -EBUSY with some printk
> messages if any of stop_machine's threads cannot start running on
> its target cpu in time.  You can enable this timeout via sysctl.
> 
> v4:
>  - move extern into linux/stop_machine.h and add include of the
>    header to kernel/sysctl.c.  Now stopmachine_timeout is available
>    only on smp.
> 
> v3:
>  - set stopmachine_timeout default to 0 (= never timeout)
> 
> v2:
>  - remove fix for warning since it will be fixed upcoming typesafe
>    patches
>  - make stopmachine_timeout from secs to msecs
>  - allow disabling timeout by setting the stopmachine_timeout to 0
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  include/linux/stop_machine.h |    3 ++
>  kernel/stop_machine.c        |   54 +++++++++++++++++++++++++++++++++++++++--
>  kernel/sysctl.c              |   12 +++++++++
>  3 files changed, 66 insertions(+), 3 deletions(-)

Looks good to me.
Ack.

Max
