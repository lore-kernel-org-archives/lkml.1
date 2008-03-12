Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbYCLHVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbYCLHVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYCLHVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:21:45 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:50084 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYCLHVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:21:44 -0400
Message-ID: <47D78485.3030104@free.fr>
Date: Wed, 12 Mar 2008 08:21:41 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc5-mm1: NO_HZ=Y && PREEMPT_RCU=Y fails to build
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
In-Reply-To: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11.03.2008 09:14, Andrew Morton a écrit :
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> 

The kernel won't build if CONFIG_NO_HZ=y and CONFIG_PREEMPT_RCU=y:

$ grep -e PREEMPT -e HZ .config
CONFIG_NO_HZ=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_RCU=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_DEBUG_PREEMPT=y
$
$ make
...
  CC      init/main.o
In file included from include/linux/rcupdate.h:60,
                 from include/linux/rculist.h:11,
                 from include/linux/dcache.h:9,
                 from include/linux/fs.h:279,
                 from include/linux/proc_fs.h:6,
                 from init/main.c:15:
include/linux/rcupreempt.h: In function 'rcu_enter_nohz':
include/linux/rcupreempt.h:91: error: 'HZ' undeclared (first use in this function)
include/linux/rcupreempt.h:91: error: (Each undeclared identifier is reported only once
include/linux/rcupreempt.h:91: error: for each function it appears in.)
include/linux/rcupreempt.h: In function 'rcu_exit_nohz':
include/linux/rcupreempt.h:99: error: 'HZ' undeclared (first use in this function)
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2
$

At first glance, I would suspect these patches:
add-warn_on_secs-macro.patch
use-warn_on_secs-in-rcupreempth.patch

~~
laurent
