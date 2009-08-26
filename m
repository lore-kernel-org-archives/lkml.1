Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbZHZNr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbZHZNr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932970AbZHZNr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:47:29 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:47000 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757361AbZHZNr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:47:28 -0400
Date: Wed, 26 Aug 2009 09:47:15 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: raz ben yehuda <raziebe@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>, Chris Friesen <cfriesen@nortel.com>,
       Mike Galbraith <efault@gmx.de>, riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <1251282598.3514.20.camel@raz>
Message-ID: <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
References: <1250983671.5688.21.camel@raz>  <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>  <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>  <1251021133.14003.172.camel@marge.simson.net> 
 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>  <1251222993.7023.53.camel@marge.simson.net>  <alpine.DEB.1.10.0908251402300.17963@gentwo.org>  <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>  <1251264700.7538.1178.camel@twins>
 <1251282598.3514.20.camel@raz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, raz ben yehuda wrote:

> How will the kernel is going to handle 32 processors machines ?  These
> numbers are no longer a science-fiction.

The kernel is already running on 4096 processor machines. Dont worry about
that.

> What i am suggesting is merely a different approach of how to handle
> multiple core systems. instead of thinking in processes, threads and so
> on i am thinking in services. Why not take  a processor and define this
> processor to do just firewalling ? encryption ? routing ? transmission ?
> video processing... and so on...

I think that is a valuable avenue to explore. What we do so far is
treating each processor equally. Dedicating a processor has benefits in
terms of cache hotness and limits OS noise.

Most of the large processor configurations already partition the system
using cpusets in order to limit the disturbance by OS processing. A set of
cpus is used for OS activities and system daemons are put into that set.
But what can be done is limited because the OS threads as well as
interrupt and timer processing etc cannot currently be moved. The ideas
that you are proposing are particularly usedful for applications that
require low latencies and cannot tolerate OS noise easily (Infiniband MPI
base jobs f.e.)


