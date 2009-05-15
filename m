Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZEOS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZEOS22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZEOS2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:28:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37321 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZEOS2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:28:06 -0400
Date: Fri, 15 May 2009 20:27:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090515182757.GA19256@elte.hu>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org> <20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0ADBA2.2020300@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> i never got a reply to my question for your previous submission:
>>
>>   http://lkml.indiana.edu/hypermail/linux/kernel/0905.1/00152.html
>>   
>
> That was in response to the mtrr patch in the dom0/core series.
>
>> Please dont post patches with ugly TODO items in them.
> I removed them in the repost.
>> Also, a more general objection is that /proc/mtrr is a legacy
>> interface, we dont really want to extend its use.
> It's not an extended use; its just making the existing interface work  
> under Xen (ie, not breaking the userspace ABI).  The only other  
> alternatives would be to 1) use Kconfig to prevent MTRR and Xen from  
> being set at the same time, or 2) put a runtime hack in to disable MTRR  
> when running under Xen.  Neither seems like a good idea when we can just  
> keep the interface working.

Right now there's no MTRR support under Xen guests and the Xen 
hypervisor was able to survive, right? Why should we do it under 
dom0?

The MTRR code is extremely fragile, we dont really need an added 
layer there. _Especially_ since /proc/mtrr is an obsolete API.

If you want to allow a guest to do MTRR ops, you can do it by 
catching the native kernel accesses to the MTRR space. There's no 
guest side support needed for that.

	Ingo
