Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbZFISnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbZFISnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZFISnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:43:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbZFISnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:43:09 -0400
Message-ID: <4A2EAD2F.5010505@redhat.com>
Date: Tue, 09 Jun 2009 21:42:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Dan Williams <dan.j.williams@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13116] Can't boot with nosmp
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>	<D9VoutSOyXP.A.xm.Vb7KKB@chimera>	<20090608091544.53a94235@nehalam>	<e9c3a7c20906080929l1a4ec739t7585f6bba54bf684@mail.gmail.com>	<20090608170437.1c2386a5@nehalam>	<e9c3a7c20906091020m19abf3b5wbbb7f5364b2d4905@mail.gmail.com>	<4A2EAA53.7060006@redhat.com> <20090609113656.46ed6335@nehalam>
In-Reply-To: <20090609113656.46ed6335@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:

  

>> This only affects reboots.  But yes, the cpumask code has bugs.  Does 
>> the .config involved select MAXSMP?
>>
>>     
>
> Patch does not fix the problem. Not sure if it is KVM only problem.
> Look like possible cpumask always equals what ACPI / SMP tables report.
> So currently looking into alloc_percpu which may not handle the possible
> but never used cpus.
>
>   

Right, it shouldn't have.

> It is x86-64 config and does not have MAXSMP set. It does have NR_CPUS set.
>   

So it's not cpumask.  Dare I suggest a bisect?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

