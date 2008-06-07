Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYFGHlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYFGHlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 03:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYFGHlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 03:41:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58206 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYFGHlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 03:41:15 -0400
Date: Sat, 07 Jun 2008 16:41:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Daniel Hokka Zakrisson" <daniel@hozac.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for  prevent fork bomb by cgroup)
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       "LKML" <linux-kernel@vger.kernel.org>, "Li Zefan" <lizf@cn.fujitsu.com>,
       "Paul Menage" <menage@google.com>
In-Reply-To: <41480.192.168.101.12.1212702756.squirrel@intranet>
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com> <41480.192.168.101.12.1212702756.squirrel@intranet>
Message-Id: <20080607160455.9C6C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I create new cgroup of number task restriction.
> > Please any comments!
> 
> Would it make more sense to implement this as part of an rlimit subsystem,
> which also supports limiting e.g. address space, CPU time, number of open
> files, etc.? If we create one subsystem per resource, I'm afraid we're
> going to see quite some time spent in all those loops, and the options for
> cgroupfs is going to become pretty long if you want to exclude just one or
> two of the subsystems for one particular mount point.

Good quistion.
task cgroup often different scope against memory, cputime, etc..

example.
	(<> mean cgroup name)

   +-----------------------------------------------------+
   | <interactive>  |         <service>                  |
   |   #task = 1000 |            #task = 5000            |
   +----------------+------------------+-----------------+
                    |  <serviceA>      |  <serviceB>     |
                    |    vaddr = 100GB |    vaddr = 200B |
                    +------------------+-----------------+

tus, we have 2 choice.

1. separate 2 cgroup.
2. implement hierarchy.

I afraid to 2 cause perfomance degression.
tus, I choiced 1.



