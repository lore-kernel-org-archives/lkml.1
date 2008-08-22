Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbYHVCYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbYHVCYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYHVCYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:24:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50432 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYHVCX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:23:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>
References: <1218865985-23403-1-git-send-email-andi@firstfloor.org>
	<m1myj63neb.fsf@frodo.ebiederm.org>
	<20080821064009.GB18831@one.firstfloor.org>
	<m163pus08m.fsf@frodo.ebiederm.org>
	<20080822015718.GC23334@one.firstfloor.org>
Date: Thu, 21 Aug 2008 19:17:34 -0700
In-Reply-To: <20080822015718.GC23334@one.firstfloor.org> (Andi Kleen's message
	of "Fri, 22 Aug 2008 03:57:18 +0200")
Message-ID: <m1zln5lrnl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Move sysctl check into debugging section and don't make it default y
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Thu, Aug 21, 2008 at 11:15:37AM -0700, Eric W. Biederman wrote:
>> Andi Kleen <andi@firstfloor.org> writes:
>> 
>> >> What is a feature change like this doing coming in after the
>> >> merge window?
>> >
>> > I considered it a "anti bloat bugfix". Adding 30k of 
>> > object code to allno was a bit too much. 
>> 
>> 30k???  Which platform are you testing on ia64????
>> 
>> On x86_64 it is 8k text and 8k data.
>
> x86-64 with 4.1. See the size output in the original commit.
>
>   text    data     bss     dec     hex filename
>   36243       0       0   36243    8d93 kernel/sysctl_check.o
>
> 36k actually.

With gcc-4.1.1 on x86_64 I see:

size kernel/sysctl.o  
   text    data     bss     dec     hex filename
   9133    8948     208   18289    4771 kernel/sysctl.o

And looking at the readelf output confirms that size isn't missing something
important.  That is extremely weird that you are seeing something so much different.
It does appear that I have CONFIG_CC_OPTIMIZE_FOR_SIZE=y but I am surprised that
even that would make such a difference.  Has gcc decided just to way over-optimize
that code?

Eric



