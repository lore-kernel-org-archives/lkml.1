Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297Ab0AUBeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0AUBeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203Ab0AUBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:34:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56302 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0AUBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:34:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Jan 2010 10:30:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100121103047.2667b864.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100121100416.88074a46.nishimura@mxp.nes.nec.co.jp>
References: <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107083440.GS3059@balbir.in.ibm.com>
	<20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107092736.GW3059@balbir.in.ibm.com>
	<20100108084727.429c40fc.kamezawa.hiroyu@jp.fujitsu.com>
	<661de9471001171130p2b0ac061he6f3dab9ef46fd06@mail.gmail.com>
	<20100118094920.151e1370.nishimura@mxp.nes.nec.co.jp>
	<4B541B44.3090407@linux.vnet.ibm.com>
	<20100119102208.59a16397.nishimura@mxp.nes.nec.co.jp>
	<661de9471001181749y2fe22a15j1c01c94aa1838e99@mail.gmail.com>
	<20100119113443.562e38ba.nishimura@mxp.nes.nec.co.jp>
	<4B552C89.8000004@linux.vnet.ibm.com>
	<20100120130902.865d8269.nishimura@mxp.nes.nec.co.jp>
	<4B56BC09.2090508@linux.vnet.ibm.com>
	<20100121100416.88074a46.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 10:04:16 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Anyway, I wouldn't say any more about the usefullness of "shared_usage_in_bytes".
> 
> But if you dare to add this interface to kernel, please and please write the documentation
> that it can be used to roughly estimate a sum of i) and ii), not sum of i) and iii), and
> can be used to decide the weight of the group only when few pages are shared between groups.
> So that users doesn't misunderstand nor misuse the interface.
> 
> And I think you should answer what Kamezawa-san pointed in http://lkml.org/lkml/2010/1/17/186.
> 
> 
I wouldn't like to say anything other than 'please add stat to global VM before
memcg if it's really important" because it seems I couldn't persuade him, he can't
do so me. I myself never think sum of rss is important.

An additonal craim I can easily think of is fork()->exit().
Assume there is a program with 1GB RSS and which invokes a helper program by
fork()->exec(). This is an usual situation. Then, sum of RSS can easily
jump up/down 1GB.

Even if getting data in atomic way, the data itself can be corrupted very
easily and the users should remove noises by themselves. So, there is no much
difference to calculate RSS in user land or kernel. The users has to measure
the status and estimate the stable value in statical technique.

Thanks,
-Kame

