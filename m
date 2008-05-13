Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbYEMTAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbYEMTAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 15:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbYEMTA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 15:00:27 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:4510 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYEMTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 15:00:27 -0400
Date: Tue, 13 May 2008 21:00:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] cpu hotplug vs scheduler
Message-ID: <20080513190024.GB6465@osiris.boeblingen.de.ibm.com>
References: <4829A6A0.5040208@qumranet.com> <4829B4AC.6090909@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4829B4AC.6090909@qumranet.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:33:00PM +0300, Avi Kivity wrote:
> Avi Kivity wrote:
>> I'm testing host cpu hotplug with kvm.  Basically running 7 guests on  
>> a 4 core machine, offlining and onlining host cpus at random.   
>> Eventually I hit this:
>>
>
> [snip oops]
>
>> This seems to be the assignment to cfs_rq after pick_next_entity().
>>
>> I'm running kvm.git, which is currently 2.6.26-rc2 plus a few kvm  
>> patches.  It could be kvm's fault, but it doesn't appear so from the  
>> traces.
>>
>
> I get the same oops running with the kvm modules unloaded.  None of  
> kvm.git's changes are in core code, so this is definitely a mainline  
> problem.
>
> It took about 40 minutes to reproduce; 1200 cpus onlined and 1200 cpus  
> offlined.

FWIW, this happens on s390 as well (without kvm support). But until now
I didn't have time to look into it. Didn't report it here yet, since we
had plenty of cpu hotplug changes in arch code, so I suspected a bug there.
This doesn't seem to be the case.

It takes only a few minutes to trigger the bug here.
