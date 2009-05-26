Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZEZVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZEZVVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZEZVVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:21:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42352 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbZEZVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:21:03 -0400
Message-ID: <4A1C5CF0.3090107@redhat.com>
Date: Tue, 26 May 2009 23:19:44 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: George Dunlap <George.Dunlap@eu.citrix.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <1242170724-13349-1-git-send-email-jeremy@goop.org>	 <20090519123548.GA26439@elte.hu> <4A14447E.9060607@goop.org>	 <20090525041057.GD9396@elte.hu> <de76405a0905260546k56bc866bx1658ec13f65e3eec@mail.gmail.com>
In-Reply-To: <de76405a0905260546k56bc866bx1658ec13f65e3eec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/09 14:46, George Dunlap wrote:
> On Mon, May 25, 2009 at 5:10 AM, Ingo Molnar<mingo@elte.hu>  wrote:
>> Note that this design problem has been created by Xen,
>> intentionally, and Xen is now suffering under those bad technical
>> choices made years ago. It's not Linux's problem.
>
> I'd like to respecfully disagree with this.

Well.  Xen *does* suffer from bad technical choices made years ago.  I'm 
pretty sure Xen would look radically different when being rewritten from 
scratch today.

One reason is that Xen predates vt and svm.  With that in mind some of 
the xen interface bits don't look *that* odd any more.  Back then it did 
made sense to handle things that way.  The ioapic hypercalls discussed 
in this thread belong into that group IMHO.

Another reason is that Xen wasn't "designed".  Xen was "hacked up".  As 
far I know there is no document which describes the overall design of 
the guest/xen ABI.  Also there is no documentation (other than code) 
which describes all details of the guest/xen ABI.  Simple reason:  The 
ABI wasn't designed.  It was hammered into shape until it worked.  On 
x86.  The guys who attempted (and failed) to port xen to ppc had alot of 
*ahem* fun with that stuff.  For example: Passing guest virtual 
addresses in (some) hypercalls.  Also direct paging mode is a very 
x86-ish and is the reason for a number of ia64-ifdefs in places where 
you don't expect them ...

cheers,
   Gerd
