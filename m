Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZAOHPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZAOHPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZAOHPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:15:08 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:49885 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbZAOHPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:15:07 -0500
Date: Wed, 14 Jan 2009 23:15:00 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       shai@scalex86.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090115071500.GA23269@localdomain>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins> <20090113123317.GA29926@elte.hu> <20090113181311.GA8075@localdomain> <20090113183420.GB10065@elte.hu> <20090113184202.GB8075@localdomain> <20090114073146.GA14767@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114073146.GA14767@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 08:31:46AM +0100, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> > You do have hardware help too to do efficient cross-node memory 
>> > traffic, dont you?
>> 
>> Of course.  A fast backplane interconnect.
>
>... so it's PCs clustered together, and called vSMP, right? ;-)
>

Well, it depends on how you define a cluster.  You can even call a
SMP  mother board a cluster of cpus :).  In that case even Sequent NUMA were
clusters, and so are some of the large core count shared memory systems
made of multiple similar boards/bricks/books (based on vendor terminology)
with a custom interconnect for cache coherency.

A vSMP system is multiple similar cpu mother boards, usually dual socket,
each board having  multiple cpus and a commodity fast interconnect for cache
coherency.  There is a VMM which  among other tasks also takes care of the
coherency, and each 'board' or 'node' can access physical memory from
another board.  There is one instance of OS running on the entire system
unlike the classical cluster where there are multiple instances of OS
and the apps under the OS have to work together as a cluster.
