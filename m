Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYFSFEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYFSFEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYFSFE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:04:26 -0400
Received: from gw.goop.org ([64.81.55.164]:53097 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbYFSFE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:04:26 -0400
Message-ID: <4859E8AF.30306@goop.org>
Date: Wed, 18 Jun 2008 22:03:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction	abstraction
References: <b020e42384197b824320.1213615800@localhost>	 <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org>	 <4859A528.1010107@goop.org>	 <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <1213835971.8011.54.camel@pasglop>
In-Reply-To: <1213835971.8011.54.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2008-06-18 at 17:24 -0700, Linus Torvalds wrote:
>   
>> On Wed, 18 Jun 2008, Jeremy Fitzhardinge wrote:
>>     
>>> Along the lines of:
>>>       
>> Hell no. There's a reason we have a special set_wrprotect() thing. We can 
>> do it more efficiently on native hardware by just clearing the bit 
>> atomically. No need to do the cmpxchg games.
>>     
>
> But we can't batch ... 
>   

Which architecture are you interested in?  If it isn't x86, you can 
probably get anything past Linus ;)

I'll do some measurements to see what effect the batchable 
ptep_set_wrprotect() has on native.  If it's significant, I'll propose 
making it conditional on CONFIG_PARAVIRT.

    J
