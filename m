Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbYFSAAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbYFSAAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:00:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbYFRX7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 19:59:52 -0400
Received: from gw.goop.org ([64.81.55.164]:58304 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbYFRX7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 19:59:50 -0400
Message-ID: <4859A149.9090004@goop.org>
Date: Wed, 18 Jun 2008 16:59:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction	abstraction
References: <b020e42384197b824320.1213615800@localhost> <1213831403.8011.24.camel@pasglop>
In-Reply-To: <1213831403.8011.24.camel@pasglop>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2008-06-16 at 04:30 -0700, Jeremy Fitzhardinge wrote:
>   
>> The only current user of this interface is mprotect
>>     
>
> Do you plan to use it with fork ultimately ?
>   

Good point, I'd overlooked that.  I guess that means using it in 
ptep_set_wrprotect().

At present the x86 ptep_set_wrprotect() just uses clear_bit on the pte, 
which is a locked cycle.  Is that significantly cheaper than an xchg + 
set?  (Same number of locked operations...)

    J
