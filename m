Return-Path: <linux-kernel-owner+w=401wt.eu-S937053AbYEUUVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937053AbYEUUVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbYEUUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:20:58 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:64231 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758908AbYEUUU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=w9p1RQ9ESLFVzWMjoJeUxgDTa05SvQBE+PF77NrofgmOA/xll6tBLQ/xxnBR/2QnF/dklfWJB2uDGaSil55qKUVPIdK/ZQLH33JzZM5txe/gNIvwPQFzR0uvLyk7+9eWuhdbMo13w98NEdnSbxKdht0cCfaLdG8lFVeEAiZygzk=
Message-ID: <48348417.9090103@googlemail.com>
Date: Wed, 21 May 2008 22:20:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: linux-next: UML build error
References: <48345B31.50904@googlemail.com> <20080521200515.GB12373@c2.user-mode-linux.org>
In-Reply-To: <20080521200515.GB12373@c2.user-mode-linux.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:

> On Wed, May 21, 2008 at 07:26:09PM +0200, Gabriel C wrote:
>>   CC      arch/um/sys-x86_64/ksyms.o
>> arch/um/sys-x86_64/ksyms.c:5: error: '__memcpy' undeclared here (not in a function)
>> arch/um/sys-x86_64/ksyms.c:5: warning: type defaults to 'int' in declaration of '__memcpy'
> 
> Does the patch below help?  There's gcc-version-dependent logic in
> include/asm-x86/string_64.h which decides whether to declare memcpy or
> __memcpy and it looks like you're hitting that.


Yes is fixes this error , however I get now another one but this one seems to be an compiler bug.

...
 CC      arch/um/sys-x86_64/um_module.o
  LD      arch/um/sys-x86_64/subarch.o
  LD      arch/um/sys-x86_64/built-in.o
  LD      arch/x86/crypto/built-in.o
  CC      kernel/sched.o
In file included from kernel/sched.c:1842:
kernel/sched_idletask.c: In function 'check_preempt_curr_idle':
kernel/sched_idletask.c:20: internal compiler error: in cgraph_estimate_size_after_inlining, at ipa-inline.c:188

...

This is gcc 4.3.0 ( with backports of some known fixed bugs ).
I try to build latest snapshot of gcc 4.3* later on today and try with this one. 

> 
> 	     	      Jeff
> 



Gabriel
