Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYHSQqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYHSQqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHSQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:45:56 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59150 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYHSQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:45:55 -0400
Message-ID: <48AAF8C0.1010806@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2008 22:15:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [discuss] memrlimit - potential applications that can use
References: <48AA73B5.7010302@linux.vnet.ibm.com> <1219161525.23641.125.camel@nimitz>
In-Reply-To: <1219161525.23641.125.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2008-08-19 at 12:48 +0530, Balbir Singh wrote:
>> 1. To provide a soft landing mechanism for applications that exceed their memory
>> limit. Currently in the memory resource controller, we swap and on failure OOM.
>> 2. To provide a mechanism similar to memory overcommit for control groups.
>> Overcommit has finer accounting, we just account for virtual address space usage.
>> 3. Vserver will directly be able to port over on top of memrlimit (their address
>> space limitation feature)
> 
> Balbir,
> 
> This all seems like a little bit too much hand waving to me.  I don't

Dave, there is no hand waving, just an honest discussion. Although, you may not
see it in the background, we still need overcommit protection and we have it
enabled by default for the system. There are applications that can deal with the
constraints setup by the administrator and constraints of the environment,
please see http://en.wikipedia.org/wiki/Autonomic_computing.

> really see a single concrete user in the "potential applications" here.
> I really don't understand why you're pushing this so hard if you don't
> have anyone to actually use it.
> 
> I just don't see anyone that *needs* it.  There's a lot of "it would be
> nice", but no "needs".

If you see the original email, I've sent - I've mentioned that we need
overcommit support (either via memrlimit or by porting over the overcommit
feature) and the exploiters you are looking for is the same as the ones who need
overcommit and RLIMIT_AS support.

On the memory overcommit front, please see PostgreSQL Server Administrator's
Guide at
http://www.network-theory.co.uk/docs/postgresql/vol3/LinuxMemoryOvercommit.html

The guide discusses turning off memory overcommit so that the database is never
OOM killed, how do we provide these guarantees for a particular control group?
We can do it system wide, but ideally we want the control point to be per
control group.

As far as other users are concerned, I've listed users of the memory limit
feature, in the original email I sent out. To try and understand your viewpoint
better, could you please tell me if

1. You are opposed to overcommit and RLIMIT_AS as features

OR

2. Expanding them to control groups

-- 
	Balbir
