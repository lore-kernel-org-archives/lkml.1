Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYERSb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYERSb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbYERSbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:31:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:52437 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYERSbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZhdnCVDicWCvZ2bt0edGBSiqGfp7HjOn9empKO6KvLQ98aP0QMAWgkbE2fTJkGa+2lK9RLepZW21AoYH4eOIcXHRy2vn73uoAAAPP8mqTNRKMc9XFRLp6OanBYCH9LVPHqAmY8Vr7xwM/2hBPsqymN72zODswUz3fXMxTfmobSY=
Message-ID: <19f34abd0805181131o43da9abfle4d9362bee900727@mail.gmail.com>
Date: Sun, 18 May 2008 20:31:18 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: Error in save_stack_trace() on x86_64?
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <19f34abd0805181013g8274992uffbdb337e72bfa98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0805110609lf3180dm3b1078e373983ad7@mail.gmail.com>
	 <48274C9E.3020608@linux.intel.com>
	 <19f34abd0805181013g8274992uffbdb337e72bfa98@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, May 18, 2008 at 7:13 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> to be improved? In the meantime, I will make some attempts at making
> the pre-pagefault frames be seen as reliable :-)

FYI, the stack looks like this:

Call Trace:
ffffffff80877ba8: 0000000000000000
ffffffff80877bb0: ffffffff80877c68
ffffffff80877bb8: ffff810007801000
ffffffff80877bc0: ffff810007801000
ffffffff80877bc8: ffffffff80877c98
ffffffff80877bd0: ffffffff8062b061
 [<ffffffff8062b061>] do_page_fault+0x31/0x70
ffffffff80877bd8: 0000000000000000
ffffffff80877be0: 0000000000000000
ffffffff80877be8: 0000000000000000
ffffffff80877bf0: 00000000000000d0
ffffffff80877bf8: 0000000000000000
ffffffff80877c00: 0000000000000000
ffffffff80877c08: ffffffff80877c18
ffffffff80877c10: 0000000000000246
ffffffff80877c18: ffffffff80877c48
ffffffff80877c20: ffffffff802241d5
 [<ffffffff802241d5>] ? cpa_fill_pool+0x135/0x140
ffffffff80877c28: ffff810000000000
ffffffff80877c30: 0000000000000000
ffffffff80877c38: ffff810000000000
ffffffff80877c40: ffff810007801000
ffffffff80877c48: ffffffff80877cc8
ffffffff80877c50: ffffffff80224c80
 [<ffffffff80224c80>] ? change_page_attr_set_clr+0x1c0/0x220
ffffffff80877c58: 00000001807dc380
ffffffff80877c60: ffffffff00000001
ffffffff80877c68: ffff810007802000
ffffffff80877c70: 0000000000000000
ffffffff80877c78: ffffffff80877c98
ffffffff80877c80: ffffffff80220a61
 [<ffffffff80220a61>] ? address_get_pte+0x11/0x30
ffffffff80877c88: 0000000000007801
ffffffff80877c90: 0000000000000001
ffffffff80877c98: 000000008020bb59
ffffffff80877ca0: ffffffff80628ff9
 [<ffffffff80628ff9>] error_exit+0x0/0x51
ffffffff80877ca8: ffffe200001e0040
ffffffff80877cb0: ffffffff80867c20
ffffffff80877cb8: ffff810007801000
ffffffff80877cc0: ffff810007801000
ffffffff80877cc8: ffffffff80877d98
ffffffff80877cd0: ffff810007801000
ffffffff80877cd8: 0000000000001000
ffffffff80877ce0: ffff810007802000
ffffffff80877ce8: 0000000000000000
ffffffff80877cf0: ffffffff807dc42a
ffffffff80877cf8: 0000000000000000
ffffffff80877d00: 0000000000000000
ffffffff80877d08: ffff810007801000
ffffffff80877d10: ffffe200001e0040
ffffffff80877d18: ffffffff80867c20
ffffffff80877d20: ffffffffffffffff
ffffffff80877d28: ffffffff8028659a
 [<ffffffff8028659a>] ? __slab_alloc+0x35a/0x560
ffffffff80877d30: 0000000000000010
ffffffff80877d38: 0000000000000246
ffffffff80877d40: ffffffff80877d58
ffffffff80877d48: 0000000000000018
ffffffff80877d50: ffffffff80286596
 [<ffffffff80286596>] ? __slab_alloc+0x356/0x560
ffffffff80877d58: 0000000000000002
ffffffff80877d60: ffffffff80386575
 [<ffffffff80386575>] ? kvasprintf+0x55/0x90
ffffffff80877d68: 000000d0ffffffff
ffffffff80877d70: 00000000000000d0
ffffffff80877d78: 0000000000000282
ffffffff80877d80: ffff810001008820
ffffffff80877d88: ffffffff80867c20
ffffffff80877d90: 00000000000000d0
ffffffff80877d98: ffffffff80877dd8
ffffffff80877da0: ffffffff80287849
 [<ffffffff80287849>] ? __kmalloc+0xf9/0x110
ffffffff80877da8: ffffffff8074d893
ffffffff80877db0: 00000000000000d0
ffffffff80877db8: ffffffff80877e38
ffffffff80877dc0: 000000000000000a
ffffffff80877dc8: ffffffff8074d889
ffffffff80877dd0: 0000000000092e80
ffffffff80877dd8: ffffffff80877e28
ffffffff80877de0: ffffffff80386575
 [<ffffffff80386575>] ? kvasprintf+0x55/0x90
ffffffff80877de8: 0000003000000018
ffffffff80877df0: ffffffff80877f18
ffffffff80877df8: ffffffff80877e58
ffffffff80877e00: 0000000000000001
ffffffff80877e08: 0000000000000004
ffffffff80877e10: ffffffff80867ac0
ffffffff80877e18: 0000000000000001
ffffffff80877e20: ffffffff80877fa8
ffffffff80877e28: ffffffff80877f08
ffffffff80877e30: ffffffff8038664b
 [<ffffffff8038664b>] ? kasprintf+0x9b/0xa0
ffffffff80877e38: 0000003000000010
ffffffff80877e40: ffffffff80877f18
ffffffff80877e48: ffffffff80877e58
ffffffff80877e50: 0000000000000000
ffffffff80877e58: ffffffff8074d881
ffffffff80877e60: 0000000000000008
ffffffff80877e68: 0000000000000008
ffffffff80877e70: 0000000000000003
ffffffff80877e78: 0000000000000001
ffffffff80877e80: ffffffff808696c0
ffffffff80877e88: 0000000000000286
ffffffff80877e90: 0000000000000000
ffffffff80877e98: 00000000000000d0
ffffffff80877ea0: 0000000000000000
ffffffff80877ea8: 00000000000000d0
ffffffff80877eb0: ffffffff80868b60
ffffffff80877eb8: 0000000000001000
ffffffff80877ec0: ffffffff8074d881
ffffffff80877ec8: ffffffff80877f08
ffffffff80877ed0: ffffffff802898fa
 [<ffffffff802898fa>] ? create_kmalloc_cache+0xaa/0xe0
ffffffff80877ed8: 0000000000000000
ffffffff80877ee0: 000000000000000d
ffffffff80877ee8: ffffffff80868d48
ffffffff80877ef0: 0000000000000001
ffffffff80877ef8: ffffffff80877fa8
ffffffff80877f00: 0000000000092e80
ffffffff80877f08: ffffffff80877f48
ffffffff80877f10: ffffffff80898193
 [<ffffffff80898193>] ? kmem_cache_init+0xf3/0x170
ffffffff80877f18: 000000000000012c
ffffffff80877f20: 0000000000000000
ffffffff80877f28: 0000000000000000
ffffffff80877f30: 0000000000000000
ffffffff80877f38: ffffffff808b14c0
ffffffff80877f40: ffffffff808d8200
ffffffff80877f48: ffffffff80877f78
ffffffff80877f50: ffffffff80882b35
 [<ffffffff80882b35>] ? start_kernel+0x245/0x340
ffffffff80877f58: ffffffff80877f78
ffffffff80877f60: ffffffff808b14c0
ffffffff80877f68: 0000000000b46a30
ffffffff80877f70: 0000000000000000
ffffffff80877f78: ffffffff80877fe8
ffffffff80877f80: ffffffff80882457
 [<ffffffff80882457>] ? x86_64_start_kernel+0x257/0x290
ffffffff80877f88: 0000000000000000
ffffffff80877f90: 0000000000000000
ffffffff80877f98: 0000000000000000
ffffffff80877fa0: 0000000000000000
ffffffff80877fa8: 80888e0000102136
ffffffff80877fb0: 00000000ffffffff
ffffffff80877fb8: 0000000000000000
ffffffff80877fc0: 0000000000000000
ffffffff80877fc8: 0000000000000000
ffffffff80877fd0: 0000000000000000
ffffffff80877fd8: 0000000000000000
ffffffff80877fe0: 0000000000000000
ffffffff80877fe8: 0000000000000000
ffffffff80877ff0: 0000000000000000

Using a simple debug patch:

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 72923ba..e33fd8f 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -244,6 +244,8 @@ static inline unsigned long
print_context_stack(struct thread_info *tinfo,
 	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
 		unsigned long addr;

+printk(KERN_EMERG "%p: %p\n", stack, (void *) *stack);
+
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
 			if ((unsigned long) stack == bp + 8) {


Is the error obvious from the stack-trace I posted above? This is not
really my field, so I might easily miss it :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
