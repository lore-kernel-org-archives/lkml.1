Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZGNRro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZGNRro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZGNRrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:47:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42856 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbZGNRrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:47:41 -0400
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where
 array  size is too large
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Benjamin Blum <bblum@google.com>
In-Reply-To: <6599ad830907141028y50f36d63h8ea06f73ff369591@mail.gmail.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	 <4A5AA3E7.9070800@cn.fujitsu.com>
	 <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	 <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
	 <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132104o55d31ccexb15e5aa35c31416e@mail.gmail.com>
	 <20090714132538.ac0bc44a.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907141028y50f36d63h8ea06f73ff369591@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 10:47:32 -0700
Message-Id: <1247593652.13426.15938.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 10:28 -0700, Paul Menage wrote:
> On Mon, Jul 13, 2009 at 9:25 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > My point is
> >  - More PIDs, More time necessary to read procs file.
> 
> Right now, many pids => impossible to read procs file due to kmalloc
> failure. (This was always the case with cpusets too). So using kmalloc
> in those cases is a strict improvement.

How big were those allocations that were failing?  The code made it
appear that order-2 (PAGE_SIZE*4) allocations were failing.  That's a
bit lower than I'd expect the page allocator to start failing.

-- Dave

