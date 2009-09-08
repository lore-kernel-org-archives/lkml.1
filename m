Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZIHHId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZIHHId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 03:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZIHHId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 03:08:33 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:40166 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZIHHIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 03:08:32 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C54DC487@exchange.ZeugmaSystems.local>
Date: Tue, 8 Sep 2009 00:08:31 -0700
Cc: Anirban Sinha <ani@anirban.org>
Content-Transfer-Encoding: 7bit
Message-Id: <9039A647-41AF-43C0-9376-F21E664F61E5@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> <dhcf5-263-13@gated-at.bofh.it> <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com> <1252218779.6126.17.camel@marge.simson.net> <1252310374.7564.6.camel@twins> <DDFD17CC94A9BD49A82147DDF7D545C54DC487@exchange.ZeugmaSystems.local>
To: Anirban Sinha <ASinha@zeugmasystems.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dario Faggioli <raistlin@linux.it>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009-09-07, at 9:42 AM, Anirban Sinha wrote:

>
>
>
> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> Sent: Mon 9/7/2009 12:59 AM
> To: Mike Galbraith
> Cc: Anirban Sinha; Lucas De Marchi; linux-kernel@vger.kernel.org;  
> Ingo Molnar
> Subject: Re: question on sched-rt group allocation cap:  
> sched_rt_runtime_us
>
> On Sun, 2009-09-06 at 08:32 +0200, Mike Galbraith wrote:
> > On Sat, 2009-09-05 at 19:32 -0700, Ani wrote:
> > > On Sep 5, 3:50 pm, Lucas De Marchi <lucas.de.mar...@gmail.com>  
> wrote:
> > > >
> > > > Indeed. I've tested this same test program in a single core  
> machine and it
> > > > produces the expected behavior:
> > > >
> > > > rt_runtime_us / rt_period_us     % loops executed in SCHED_OTHER
> > > > 95%                              4.48%
> > > > 60%                              54.84%
> > > > 50%                              86.03%
> > > > 40%                              OTHER completed first
> > > >
> > >
> > > Hmm. This does seem to indicate that there is some kind of
> > > relationship with SMP. So I wonder whether there is a way to  
> turn this
> > > 'RT bandwidth accumulation' heuristic off.
> >
> > No there isn't..
>
> Actually there is, use cpusets to carve the system into partitions.

hmm. ok. I looked at the code a little bit. It seems to me that the  
'borrowing' of RT runtimes occurs only from rt runqueues belonging to  
the same root domain. And partition_sched_domains() is the only  
external interface that can be used to create root domain out of a CPU  
set. But then I think it needs to have CGROUPS/USER groups enabled?  
Right?

--Ani


>
>
>

