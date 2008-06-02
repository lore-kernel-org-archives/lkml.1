Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYFBJtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYFBJtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 05:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbYFBJsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 05:48:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60281 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbYFBJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 05:48:38 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <11041923.1212400091150.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 2 Jun 2008 18:48:11 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, xemul@openvz.org,
       menage@google.com, yamamoto@valinux.co.jp, lizf@cn.fujitsu.com
In-Reply-To: <4843903F.1090009@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <4843903F.1090009@linux.vnet.ibm.com>
 <4841886A.1000901@linux.vnet.ibm.com> <48413482.5080409@linux.vnet.ibm.com> <48407DC3.8060001@linux.vnet.ibm.com> <20080530104312.4b20cc60.kamezawa.hiroyu@jp.fujitsu.com> <20080530104515.9afefdbb.kamezawa.hiroyu@jp.fujitsu.com> <25360008.1212199156779.kamezawa.hiroyu@jp.fujitsu.com> <26479923.1212245220415.kamezawa.hiroyu@jp.fujitsu.com> <5049235.1212280513897.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Why don't we add soft limits, so that we don't have to go to the kernel and
>change limits frequently. One missing piece in the memory controller is that 
we
>don't shrink the memory controller when limits change or when tasks move. I
>think soft limits is a better solution.
>
My code adds shirinking_at_limit_change. I'm now try to write migrate_resouces
_at_task_move. (But seems not so easy to be implemented in 
clean/fast way.)

I have no objection to soft-limit if it's easy to be implemented. (I wrote
my explanation was just an example and we could add more knobs.) 
_But_ I think that something to control multiple cgroups with regard to hierar
chy under some policy never be a simple one. Adding some knobs for each cgroup
s to do soft-limit will be simple one if no hirerachy.

Memory controller's  difference from scheduler's hirerachy is that we have to 
do multilevel page reclaim with feedback under some policy (not only one..). 
Even without hierarhcy, we _did_ make the kernel's LRU logic more complicated.
But we can get a help from the middleware here, I think.

My goal is never to make cgroup slow or complicated. If it's slow, 
I'd like to say "ok, please use VMware.It's simpler and enough fast for you." 
"How fast it works rather than Hardware-Virtualization" is the most
important for me. It should be much more faster.

>Thanks for patiently explaining all of this.
>
Thanks, I'm sorry for my poor explanation skill.

Regards,
-Kame

