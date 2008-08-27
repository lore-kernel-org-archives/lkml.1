Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYH0V7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYH0V7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYH0V7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:59:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:14186 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYH0V7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:59:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=F2kC725cvspDum4hM+j5Dl8nmAhUcjFOEEuNVxx8xYqiNv/Ur7XxLVgkUS6SajNyjg
         h0jggHgqbYtMh+ZJkIPz7tGIA67cEuFwXBXjDd+orNohzMPjrqkAlFx24j1toWMNHSGx
         zuel+maqPH4Cza3+PiOgY71gGomlOSm3HKAzo=
Date: Thu, 28 Aug 2008 02:00:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080827220050.GA32334@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <20080826225519.GC27724@x200.localdomain> <20080827213211.GA31861@x200.localdomain> <20080827214652.GA32163@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080827214652.GA32163@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 01:46:52AM +0400, Alexey Dobriyan wrote:
> On Thu, Aug 28, 2008 at 01:32:11AM +0400, Alexey Dobriyan wrote:
> > > And run to confirm that attach/detach/exec program still crashes it.
> > > There is PREEMPT_RCU now so it will be even more not funny.
> > 
> > As promised, quickly reproducible via expt_ptratt.c:
> 
> Another one:

And overwritten poison if run in parallel with

	while true; do
		killall -9 expl_ptratt
		killall -9 exe
	done

=============================================================================
BUG utrace: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88017c31e7b0-0xffff88017c31e7f0. First byte 0x6c instead of 0x6b
INFO: Allocated in utrace_attach_task+0x1f4/0x3d0 age=13 cpu=1 pid=5377
INFO: Freed in utrace_free+0x16/0x20 age=5 cpu=1 pid=5377
INFO: Slab 0xffffe2000532ae90 objects=21 used=2 fp=0xffff88017c31e780 flags=0x80000000000000c3
INFO: Object 0xffff88017c31e780 @offset=1920 fp=0xffff88017c31e540

Bytes b4 0xffff88017c31e770:  fc 1f ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ü.ÿÿ....ZZZZZZZZ
  Object 0xffff88017c31e780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88017c31e790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88017c31e7a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88017c31e7b0:  6c 6c 6b 6b 6b 6b 6b 6b ff ff ff ff 6b 6b 6b 6b llkkkkkkÿÿÿÿkkkk
  Object 0xffff88017c31e7c0:  ff ff ff ff ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b ÿÿÿÿÿÿÿÿkkkkkkkk
  Object 0xffff88017c31e7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88017c31e7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88017c31e7f0:  6a 6b 6b 6b 6b 6b 6b a5                         jkkkkkk¥        
 Redzone 0xffff88017c31e7f8:  bb bb bb bb bb bb bb bb                         »»»»»»»»        
 Padding 0xffff88017c31e838:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 5382, comm: expl_ptratt Tainted: G        W 2.6.27-rc4-next-20080827-utrace #5
Call Trace:
 [<ffffffff8028f989>] print_trailer+0xf9/0x160
 [<ffffffff8028ff75>] check_bytes_and_report+0xa5/0xd0
 [<ffffffff80290048>] check_object+0xa8/0x250
 [<ffffffff80291173>] __slab_alloc+0x4f3/0x670
 [<ffffffff8025f304>] ? utrace_attach_task+0x1f4/0x3d0
 [<ffffffff8025f304>] ? utrace_attach_task+0x1f4/0x3d0
 [<ffffffff80291721>] kmem_cache_alloc+0xb1/0xd0
 [<ffffffff8025f304>] utrace_attach_task+0x1f4/0x3d0
 [<ffffffff8023b977>] ptrace_attach_utrace+0x27/0x80
 [<ffffffff8023c3e8>] ptrace_attach+0x48/0x1b0
 [<ffffffff8023c610>] sys_ptrace+0xc0/0xd0
 [<ffffffff8020b73b>] system_call_fastpath+0x16/0x1b
FIX utrace: Restoring 0xffff88017c31e7b0-0xffff88017c31e7f0=0x6b

FIX utrace: Marking all objects used

