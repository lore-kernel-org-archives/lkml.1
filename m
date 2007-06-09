Return-Path: <linux-kernel-owner+w=401wt.eu-S1030536AbXFICxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030536AbXFICxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 22:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968507AbXFICxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 22:53:12 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:63765 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968490AbXFICxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 22:53:10 -0400
Message-ID: <466A15FB.7010608@linux.vnet.ibm.com>
Date: Sat, 09 Jun 2007 08:22:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [0/1] [patch -mm] Add containerstats (v3)
References: <20070608181346.15764.2467.sendpatchset@balbir-laptop> <20070608124816.fa1e70d8.akpm@linux-foundation.org>
In-Reply-To: <20070608124816.fa1e70d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 08 Jun 2007 23:43:46 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This patch implements per container statistics infrastructure and re-uses
>> code from the taskstats interface.
> 
> boggle.
> 
> Symbol: CONTAINERS [=y]
>   Selected by: CONTAINER_DEBUG || CPUSETS && SMP || CONTAINER_CPUACCT
> 
> Paul, that's just bizarre.  How come it was done this way?
> 
> <struggles for a while, works out how to make CONFIG_CONTAINERS go away>
> 
> OK, so taskstats.c still compiles, but I'm surprised.  Shouldn't all that
> newly-added container stuff in taskstats.c be inside CONFIG_CONTAINERS?

Hi, Andrew,

I've added a definition of containerstats_build() even when CONFIG_CONTAINERS
is turned off, it simply returns -EINVAL. That's why taskstats.c compiles,
I could add an #ifdef and move the containers commands under CONFIG_CONTAINERS,
but I felt taskstats.c could be clean without any #ifdef's hanging around
(as much as possible).

In the next iteration, I could move out all the code to containerstats.c
and make containerstats.c depend on CONFIG_CONTAINERS

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
