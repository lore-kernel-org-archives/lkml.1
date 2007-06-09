Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbXFIICc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbXFIICc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbXFIICT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:02:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbXFIICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:02:17 -0400
Date: Sat, 9 Jun 2007 01:02:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Emelianov" <xemul@openvz.org>
Subject: Re: [0/1] [patch -mm] Add containerstats (v3)
Message-Id: <20070609010202.4c2b51fb.akpm@linux-foundation.org>
In-Reply-To: <6599ad830706090009q25e13ff6ybad7d7f7db21cd48@mail.gmail.com>
References: <20070608181346.15764.2467.sendpatchset@balbir-laptop>
	<20070608124816.fa1e70d8.akpm@linux-foundation.org>
	<6599ad830706090009q25e13ff6ybad7d7f7db21cd48@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 00:09:55 -0700 "Paul Menage" <menage@google.com> wrote:

> On 6/8/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 08 Jun 2007 23:43:46 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> > > This patch implements per container statistics infrastructure and re-uses
> > > code from the taskstats interface.
> >
> > boggle.
> >
> > Symbol: CONTAINERS [=y]
> >   Selected by: CONTAINER_DEBUG || CPUSETS && SMP || CONTAINER_CPUACCT
> >
> > Paul, that's just bizarre.  How come it was done this way?
> 
> Containers on their own without any subsystems aren't hugely useful.
> So the plan was that any container subsystem would "select CONTAINERS"
> to cause the container framework to be built. I'm happy to change it
> to invert the dependencies if you'd prefer.
> 

- CONTAINER_DEBUG should depend on CONTAINERS

- the CPUSETS && SMP is weird and should be deleted, unless I'm missing
  something

- CONTAINERS should depend on CPUSETS

- That leaves CONTAINER_CPUACCT.  One _could_ `select' CONTAINERS if
  CONTAINER_CPUACCT but I suspect that'll screw up the above (select does
  odd things).  I think it's reasonable to have a CONTAINERS menu and under
  that, all the clients of it: CONTAINER_CPUACCT, CONTAINER_MEMORY_CONTROL,
  etc.


