Return-Path: <linux-kernel-owner+w=401wt.eu-S1755694AbZGNTKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbZGNTKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZGNTKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:10:11 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:47788 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753665AbZGNTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:10:10 -0400
In-Reply-To: <20090714100440.6283.A69D9226@jp.fujitsu.com>
References: <20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com> <20090714100440.6283.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <9B7C6FE2-D946-4286-9537-C4A715997B89@embeddedalley.com>
Cc: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
Date: Tue, 14 Jul 2009 12:13:32 -0700
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 13, 2009, at 6:43 PM, KOSAKI Motohiro wrote:

> I like multiple threshold and per-thresold file-descriptor.
> it solve multiple waiters issue.
>
> but How about this?
>
>   /cgroup
>     /group1
>       /notifications
>          /threashold-A
>          /threashold-B

Why are you making this so complicated?
As a group, there is a limit and a notification
threshold.  Use the power of the cgroup hierarchy
if you want something with related limits and
different thresholds.  I don't understand the system
design  that would desire group cooperation
but yet different threshold notifications, except in
the case of upper/lower limits.  I'm not arguing
you can't do it, but the value in doing so.

The complexity of the event delivery will cause
extensive discussion as well.  You have great
ideas but scratch just a little below the surface
and there are complex problems to solve.  For
example, if you have a "below limit" notification
I can think of many challenges to solve.  Do you
constantly deliver the event?  Only once on crossing?
At some time interval?  How often? On a new attach
to the event?  Hysteresis? How do you control these?

The purpose of this memory notification was to improve
upon a previous attempt at such a feature.  It's a useful
feature that is today being used in some applications
to successfully manage the constrained resource.

If you look at my presentation from the last ELC, you
will see this patch is one small step of many to improve
resource management.  This event notification discussion
is important, but still just a tiny implementation detail in
a bigger resource management scheme.  We need to
make the small steps to make people aware of new features,
write applications that utilize these features, and to
perhaps discover something even better we aren't
even considering.

Thanks.

	-- Dan

