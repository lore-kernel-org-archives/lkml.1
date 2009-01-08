Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbZAHErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbZAHErT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZAHErJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:47:09 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:49763 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbZAHErI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:47:08 -0500
Date: Thu, 8 Jan 2009 13:41:33 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: balbir@linux.vnet.ibm.com
Cc: nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>, riel@redhat.com,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches
Message-Id: <20090108134133.6edf461f.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090108035930.GB7294@balbir.in.ibm.com>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
	<20090108093040.22d5f281.kamezawa.hiroyu@jp.fujitsu.com>
	<20090108035930.GB7294@balbir.in.ibm.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   1. please fix current bugs on hierarchy management, before new feature.
> >      AFAIK, OOM-Kill under hierarchy is broken. (I have patches but waits for
> >      merge window close.)
> 
> I've not hit the OOM-kill issue under hierarchy so far, is the OOM
> killer selecting a bad task to kill? I'll debug/reproduce the issue.
> I am not posting these patches for inclusion, fixing bugs is
> definitely the highest priority.
> 
I agree.

Just FYI, I have several bug fix patches for current memcg(that is for .29).
I've been testing them now, and it survives my test(rmdir aftre task move
under memory pressure and page migration) w/o big problem(except oom) for hours
in both use_hierarchy==0/1 case.

> >      I wonder there will be some others. Lockdep error which Nishimura reported
> >      are all fixed now ?
> 
> I run all my kernels and tests with lockdep enabled, I did not see any
> lockdep errors showing up.
> 
I think Paul's hierarchy_mutex patches fixed the dead lock, I haven't seen
the dead lock after the patch.
(Although, it may cause another dead lock when other subsystems are added.)


Thanks,
Daisuke Nishimura.
