Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZAVGO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZAVGO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 01:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbZAVGOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 01:14:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZAVGOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 01:14:30 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Thu, 22 Jan 2009 11:42:00 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, Chris Snook <csnook@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Menage <menage@google.com>,
       containers@lists.linux-foundation.org
References: <200901211638.23101.knikanth@suse.de> <200901221043.13684.knikanth@suse.de> <d6200be20901212139u3683c829x4db1840a28986a6f@mail.gmail.com>
In-Reply-To: <d6200be20901212139u3683c829x4db1840a28986a6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901221142.00803.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 11:09:45 Arve Hjønnevåg wrote:
> On Wed, Jan 21, 2009 at 9:13 PM, Nikanth Karthikesan <knikanth@suse.de> 
wrote:
> > To use oom_adj effectively one should continuously monitor oom_score of
> > all the processes, which is a complex moving target and keep on adjusting
> > the oom_adj of many tasks which still cannot guarantee the order. This
> > controller is deterministic and hence easier to use.
>
> Why not add an option to make oom_adj ensure strict ordering instead?

This could be done in 2 ways.
1. Make oom_adj itself strict.(based on some other parameter?)
- Adds to confusion whether the current oom_adj is a strict value or the usual 
suggestion. 
- It would disable the oom_adj suggestion which could have been used till now. 
- It is a public interface, and changing that might break some one's script.

2. Add addtional parameter, say  /proc/<pid>/oom_order
- Not easy to use.
- Say I had assigned the oom.victim to a task and it had forked a lot. Now to 
change the value for all the tasks it is easier with cgroups.
- Some optimization that Kame specified earlier would be harder to achieve.

Basically oom-controller implements option 2, using cgroups which can be 
thought of as a modern interface for proc. Also it could be used along with 
other cgroup controllers like the group scheduler. Say you have 2 groups of 
tasks, clubed as entertainment and science, you could use the group scheduler 
to give more CPU bandwidth to science and instruct oom-controller to kill 
entertainment tasks in case of OOM situation.

Thanks
Nikanth

