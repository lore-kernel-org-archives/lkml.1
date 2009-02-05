Return-Path: <linux-kernel-owner+w=401wt.eu-S1758767AbZBEQFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbZBEQFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZBEQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:04:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:59841 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbZBEQEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FBubt1+SczogeC/g4VisIYrmIaxLzjiLCNb8TV3+Ovog2PrLpu2Qko5kSdC6ZBzg0K
         JY3i/cFID1PWNdGgpcsrdAbjBNHLzH3RkvNXRvoWo4ekTDB3/nxrUuTo5QMRcwnrR4zp
         V1AfjCFm87jShNk4GwI4QFhH4KkWGApZE3BeI=
Message-ID: <498B0E13.7060604@gmail.com>
Date: Fri, 06 Feb 2009 01:04:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Brian Gerst <brgerst@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: style fascism for xen assemblies
References: <4983AC87.5000304@goop.org> <498A87B5.3020808@gmail.com> <20090205150028.GD23903@elte.hu>
In-Reply-To: <20090205150028.GD23903@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: style cleanup

Make the following sytle cleanups.

* drop unnecessary //#include from xen-asm_32.S
* compulsive adding of space after comma
* reformat multiline comments

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Committed to #tj-upstream.  Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

to receive the modpost fix and this one.

Thanks.

 arch/x86/xen/xen-asm.S    |   73 ++++++++--------
 arch/x86/xen/xen-asm_32.S |  214 ++++++++++++++++++++++-----------------------
 arch/x86/xen/xen-asm_64.S |  103 +++++++++++-----------
 3 files changed, 193 insertions(+), 197 deletions(-)

diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
index 4c6f967..463d8ac 100644
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -1,14 +1,14 @@
 /*
-	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
-	The inline versions are the same as the direct-use versions, with the
-	pre- and post-amble chopped off.
-
-	This code is encoded for size rather than absolute efficiency,
-	with a view to being able to inline as much as possible.
-
-	We only bother with direct forms (ie, vcpu in percpu data) of
-	the operations here; the indirect forms are better handled in
-	C, since they're generally too large to inline anyway.
+ * Asm versions of Xen pv-ops, suitable for either direct use or
+ * inlining.  The inline versions are the same as the direct-use
+ * versions, with the pre- and post-amble chopped off.
+ *
+ * This code is encoded for size rather than absolute efficiency, with
+ * a view to being able to inline as much as possible.
+ *
+ * We only bother with direct forms (ie, vcpu in percpu data) of the
+ * operations here; the indirect forms are better handled in C, since
+ * they're generally too large to inline anyway.
  */
 
 #include <asm/asm-offsets.h>
@@ -18,17 +18,17 @@
 #include "xen-asm.h"
 
 /*
-	Enable events.  This clears the event mask and tests the pending
-	event status with one and operation.  If there are pending
-	events, then enter the hypervisor to get them handled.
+ * Enable events.  This clears the event mask and tests the pending
+ * event status with one and operation.  If there are pending events,
+ * then enter the hypervisor to get them handled.
  */
 ENTRY(xen_irq_enable_direct)
 	/* Unmask events */
 	movb $0, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 
-	/* Preempt here doesn't matter because that will deal with
-	   any pending interrupts.  The pending check may end up being
-	   run on the wrong CPU, but that doesn't hurt. */
+	/* Preempt here doesn't matter because that will deal with any
+	 * pending interrupts.  The pending check may end up being run
+	 * on the wrong CPU, but that doesn't hurt. */
 
 	/* Test for pending */
 	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
@@ -43,8 +43,8 @@ ENDPATCH(xen_irq_enable_direct)
 
 
 /*
-	Disabling events is simply a matter of making the event mask
-	non-zero.
+ * Disabling events is simply a matter of making the event mask
+ * non-zero.
  */
 ENTRY(xen_irq_disable_direct)
 	movb $1, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
@@ -54,18 +54,18 @@ ENDPATCH(xen_irq_disable_direct)
 	RELOC(xen_irq_disable_direct, 0)
 
 /*
-	(xen_)save_fl is used to get the current interrupt enable status.
-	Callers expect the status to be in X86_EFLAGS_IF, and other bits
-	may be set in the return value.  We take advantage of this by
-	making sure that X86_EFLAGS_IF has the right value (and other bits
-	in that byte are 0), but other bits in the return value are
-	undefined.  We need to toggle the state of the bit, because
-	Xen and x86 use opposite senses (mask vs enable).
+ * (xen_)save_fl is used to get the current interrupt enable status.
+ * Callers expect the status to be in X86_EFLAGS_IF, and other bits
+ * may be set in the return value.  We take advantage of this by
+ * making sure that X86_EFLAGS_IF has the right value (and other bits
+ * in that byte are 0), but other bits in the return value are
+ * undefined.  We need to toggle the state of the bit, because Xen and
+ * x86 use opposite senses (mask vs enable).
  */
 ENTRY(xen_save_fl_direct)
 	testb $0xff, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
 	setz %ah
-	addb %ah,%ah
+	addb %ah, %ah
 ENDPATCH(xen_save_fl_direct)
 	ret
 	ENDPROC(xen_save_fl_direct)
@@ -73,12 +73,11 @@ ENDPATCH(xen_save_fl_direct)
 
 
 /*
-	In principle the caller should be passing us a value return
-	from xen_save_fl_direct, but for robustness sake we test only
-	the X86_EFLAGS_IF flag rather than the whole byte. After
-	setting the interrupt mask state, it checks for unmasked
-	pending events and enters the hypervisor to get them delivered
-	if so.
+ * In principle the caller should be passing us a value return from
+ * xen_save_fl_direct, but for robustness sake we test only the
+ * X86_EFLAGS_IF flag rather than the whole byte. After setting the
+ * interrupt mask state, it checks for unmasked pending events and
+ * enters the hypervisor to get them delivered if so.
  */
 ENTRY(xen_restore_fl_direct)
 #ifdef CONFIG_X86_64
@@ -87,9 +86,9 @@ ENTRY(xen_restore_fl_direct)
 	testb $X86_EFLAGS_IF>>8, %ah
 #endif
 	setz PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_mask
-	/* Preempt here doesn't matter because that will deal with
-	   any pending interrupts.  The pending check may end up being
-	   run on the wrong CPU, but that doesn't hurt. */
+	/* Preempt here doesn't matter because that will deal with any
+	 * pending interrupts.  The pending check may end up being run
+	 * on the wrong CPU, but that doesn't hurt. */
 
 	/* check for unmasked and pending */
 	cmpw $0x0001, PER_CPU_VAR(xen_vcpu_info) + XEN_vcpu_info_pending
@@ -103,8 +102,8 @@ ENDPATCH(xen_restore_fl_direct)
 
 
 /*
-	Force an event check by making a hypercall,
-	but preserve regs before making the call.
+ * Force an event check by making a hypercall, but preserve regs
+ * before making the call.
  */
 check_events:
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index 082d173..ce70bec 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -1,17 +1,16 @@
 /*
-	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
-	The inline versions are the same as the direct-use versions, with the
-	pre- and post-amble chopped off.
-
-	This code is encoded for size rather than absolute efficiency,
-	with a view to being able to inline as much as possible.
-
-	We only bother with direct forms (ie, vcpu in pda) of the operations
-	here; the indirect forms are better handled in C, since they're
-	generally too large to inline anyway.
+ * Asm versions of Xen pv-ops, suitable for either direct use or
+ * inlining.  The inline versions are the same as the direct-use
+ * versions, with the pre- and post-amble chopped off.
+ *
+ * This code is encoded for size rather than absolute efficiency, with
+ * a view to being able to inline as much as possible.
+ *
+ * We only bother with direct forms (ie, vcpu in pda) of the
+ * operations here; the indirect forms are better handled in C, since
+ * they're generally too large to inline anyway.
  */
 
-//#include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
 #include <asm/processor-flags.h>
 #include <asm/segment.h>
@@ -21,8 +20,8 @@
 #include "xen-asm.h"
 
 /*
-	Force an event check by making a hypercall,
-	but preserve regs before making the call.
+ * Force an event check by making a hypercall, but preserve regs
+ * before making the call.
  */
 check_events:
 	push %eax
@@ -35,10 +34,10 @@ check_events:
 	ret
 
 /*
-	We can't use sysexit directly, because we're not running in ring0.
-	But we can easily fake it up using iret.  Assuming xen_sysexit
-	is jumped to with a standard stack frame, we can just strip it
-	back to a standard iret frame and use iret.
+ * We can't use sysexit directly, because we're not running in ring0.
+ * But we can easily fake it up using iret.  Assuming xen_sysexit is
+ * jumped to with a standard stack frame, we can just strip it back to
+ * a standard iret frame and use iret.
  */
 ENTRY(xen_sysexit)
 	movl PT_EAX(%esp), %eax			/* Shouldn't be necessary? */
@@ -49,33 +48,31 @@ ENTRY(xen_sysexit)
 ENDPROC(xen_sysexit)
 
 /*
-	This is run where a normal iret would be run, with the same stack setup:
-	      8: eflags
-	      4: cs
-	esp-> 0: eip
-
-	This attempts to make sure that any pending events are dealt
-	with on return to usermode, but there is a small window in
-	which an event can happen just before entering usermode.  If
-	the nested interrupt ends up setting one of the TIF_WORK_MASK
-	pending work flags, they will not be tested again before
-	returning to usermode. This means that a process can end up
-	with pending work, which will be unprocessed until the process
-	enters and leaves the kernel again, which could be an
-	unbounded amount of time.  This means that a pending signal or
-	reschedule event could be indefinitely delayed.
-
-	The fix is to notice a nested interrupt in the critical
-	window, and if one occurs, then fold the nested interrupt into
-	the current interrupt stack frame, and re-process it
-	iteratively rather than recursively.  This means that it will
-	exit via the normal path, and all pending work will be dealt
-	with appropriately.
-
-	Because the nested interrupt handler needs to deal with the
-	current stack state in whatever form its in, we keep things
-	simple by only using a single register which is pushed/popped
-	on the stack.
+ * This is run where a normal iret would be run, with the same stack setup:
+ *	8: eflags
+ *	4: cs
+ *	esp-> 0: eip
+ *
+ * This attempts to make sure that any pending events are dealt with
+ * on return to usermode, but there is a small window in which an
+ * event can happen just before entering usermode.  If the nested
+ * interrupt ends up setting one of the TIF_WORK_MASK pending work
+ * flags, they will not be tested again before returning to
+ * usermode. This means that a process can end up with pending work,
+ * which will be unprocessed until the process enters and leaves the
+ * kernel again, which could be an unbounded amount of time.  This
+ * means that a pending signal or reschedule event could be
+ * indefinitely delayed.
+ *
+ * The fix is to notice a nested interrupt in the critical window, and
+ * if one occurs, then fold the nested interrupt into the current
+ * interrupt stack frame, and re-process it iteratively rather than
+ * recursively.  This means that it will exit via the normal path, and
+ * all pending work will be dealt with appropriately.
+ *
+ * Because the nested interrupt handler needs to deal with the current
+ * stack state in whatever form its in, we keep things simple by only
+ * using a single register which is pushed/popped on the stack.
  */
 ENTRY(xen_iret)
 	/* test eflags for special cases */
@@ -85,13 +82,13 @@ ENTRY(xen_iret)
 	push %eax
 	ESP_OFFSET=4	# bytes pushed onto stack
 
-	/* Store vcpu_info pointer for easy access.  Do it this
-	   way to avoid having to reload %fs */
+	/* Store vcpu_info pointer for easy access.  Do it this way to
+	 * avoid having to reload %fs */
 #ifdef CONFIG_SMP
 	GET_THREAD_INFO(%eax)
-	movl TI_cpu(%eax),%eax
-	movl __per_cpu_offset(,%eax,4),%eax
-	mov per_cpu__xen_vcpu(%eax),%eax
+	movl TI_cpu(%eax), %eax
+	movl __per_cpu_offset(,%eax,4), %eax
+	mov per_cpu__xen_vcpu(%eax), %eax
 #else
 	movl per_cpu__xen_vcpu, %eax
 #endif
@@ -100,36 +97,37 @@ ENTRY(xen_iret)
 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
 
 	/* Maybe enable events.  Once this happens we could get a
-	   recursive event, so the critical region starts immediately
-	   afterwards.  However, if that happens we don't end up
-	   resuming the code, so we don't have to be worried about
-	   being preempted to another CPU. */
+	 * recursive event, so the critical region starts immediately
+	 * afterwards.  However, if that happens we don't end up
+	 * resuming the code, so we don't have to be worried about
+	 * being preempted to another CPU. */
 	setz XEN_vcpu_info_mask(%eax)
 xen_iret_start_crit:
 
 	/* check for unmasked and pending */
 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
 
-	/* If there's something pending, mask events again so we
-	   can jump back into xen_hypervisor_callback */
+	/* If there's something pending, mask events again so we can
+	 * jump back into xen_hypervisor_callback */
 	sete XEN_vcpu_info_mask(%eax)
 
 	popl %eax
 
 	/* From this point on the registers are restored and the stack
-	   updated, so we don't need to worry about it if we're preempted */
+	 * updated, so we don't need to worry about it if we're
+	 * preempted */
 iret_restore_end:
 
 	/* Jump to hypervisor_callback after fixing up the stack.
-	   Events are masked, so jumping out of the critical
-	   region is OK. */
+	 * Events are masked, so jumping out of the critical region is
+	 * OK. */
 	je xen_hypervisor_callback
 
 1:	iret
 xen_iret_end_crit:
 .section __ex_table,"a"
 	.align 4
-	.long 1b,iret_exc
+	.long 1b, iret_exc
 .previous
 
 hyper_iret:
@@ -139,55 +137,55 @@ hyper_iret:
 	.globl xen_iret_start_crit, xen_iret_end_crit
 
 /*
-   This is called by xen_hypervisor_callback in entry.S when it sees
-   that the EIP at the time of interrupt was between xen_iret_start_crit
-   and xen_iret_end_crit.  We're passed the EIP in %eax so we can do
-   a more refined determination of what to do.
-
-   The stack format at this point is:
-	----------------
-	 ss		: (ss/esp may be present if we came from usermode)
-	 esp		:
-	 eflags		}  outer exception info
-	 cs		}
-	 eip		}
-	---------------- <- edi (copy dest)
-	 eax		:  outer eax if it hasn't been restored
-	----------------
-	 eflags		}  nested exception info
-	 cs		}   (no ss/esp because we're nested
-	 eip		}    from the same ring)
-	 orig_eax	}<- esi (copy src)
-	 - - - - - - - -
-	 fs		}
-	 es		}
-	 ds		}  SAVE_ALL state
-	 eax		}
-	  :		:
-	 ebx		}<- esp
-	----------------
-
-   In order to deliver the nested exception properly, we need to shift
-   everything from the return addr up to the error code so it
-   sits just under the outer exception info.  This means that when we
-   handle the exception, we do it in the context of the outer exception
-   rather than starting a new one.
-
-   The only caveat is that if the outer eax hasn't been
-   restored yet (ie, it's still on stack), we need to insert
-   its value into the SAVE_ALL state before going on, since
-   it's usermode state which we eventually need to restore.
+ * This is called by xen_hypervisor_callback in entry.S when it sees
+ * that the EIP at the time of interrupt was between
+ * xen_iret_start_crit and xen_iret_end_crit.  We're passed the EIP in
+ * %eax so we can do a more refined determination of what to do.
+ *
+ * The stack format at this point is:
+ *	----------------
+ *	 ss		: (ss/esp may be present if we came from usermode)
+ *	 esp		:
+ *	 eflags		}  outer exception info
+ *	 cs		}
+ *	 eip		}
+ *	---------------- <- edi (copy dest)
+ *	 eax		:  outer eax if it hasn't been restored
+ *	----------------
+ *	 eflags		}  nested exception info
+ *	 cs		}   (no ss/esp because we're nested
+ *	 eip		}    from the same ring)
+ *	 orig_eax	}<- esi (copy src)
+ *	 - - - - - - - -
+ *	 fs		}
+ *	 es		}
+ *	 ds		}  SAVE_ALL state
+ *	 eax		}
+ *	  :		:
+ *	 ebx		}<- esp
+ *	----------------
+ *
+ * In order to deliver the nested exception properly, we need to shift
+ * everything from the return addr up to the error code so it sits
+ * just under the outer exception info.  This means that when we
+ * handle the exception, we do it in the context of the outer
+ * exception rather than starting a new one.
+ *
+ * The only caveat is that if the outer eax hasn't been restored yet
+ * (ie, it's still on stack), we need to insert its value into the
+ * SAVE_ALL state before going on, since it's usermode state which we
+ * eventually need to restore.
  */
 ENTRY(xen_iret_crit_fixup)
 	/*
-	   Paranoia: Make sure we're really coming from kernel space.
-	   One could imagine a case where userspace jumps into the
-	   critical range address, but just before the CPU delivers a GP,
-	   it decides to deliver an interrupt instead.  Unlikely?
-	   Definitely.  Easy to avoid?  Yes.  The Intel documents
-	   explicitly say that the reported EIP for a bad jump is the
-	   jump instruction itself, not the destination, but some virtual
-	   environments get this wrong.
+	 * Paranoia: Make sure we're really coming from kernel space.
+	 * One could imagine a case where userspace jumps into the
+	 * critical range address, but just before the CPU delivers a
+	 * GP, it decides to deliver an interrupt instead.  Unlikely?
+	 * Definitely.  Easy to avoid?  Yes.  The Intel documents
+	 * explicitly say that the reported EIP for a bad jump is the
+	 * jump instruction itself, not the destination, but some
+	 * virtual environments get this wrong.
 	 */
 	movl PT_CS(%esp), %ecx
 	andl $SEGMENT_RPL_MASK, %ecx
@@ -202,10 +200,10 @@ ENTRY(xen_iret_crit_fixup)
 	cmp $iret_restore_end, %eax
 	jae 1f
 
-	movl 0+4(%edi),%eax		/* copy EAX (just above top of frame) */
+	movl 0+4(%edi), %eax		/* copy EAX (just above top of frame) */
 	movl %eax, PT_EAX(%esp)
 
-	lea ESP_OFFSET(%edi),%edi	/* move dest up over saved regs */
+	lea ESP_OFFSET(%edi), %edi	/* move dest up over saved regs */
 
 	/* set up the copy */
 1:	std
@@ -213,6 +211,6 @@ ENTRY(xen_iret_crit_fixup)
 	rep movsl
 	cld
 
-	lea 4(%edi),%esp		/* point esp to new frame */
+	lea 4(%edi), %esp		/* point esp to new frame */
 2:	jmp xen_do_upcall
 
diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index d205a28..680224d 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -1,14 +1,14 @@
 /*
-	Asm versions of Xen pv-ops, suitable for either direct use or inlining.
-	The inline versions are the same as the direct-use versions, with the
-	pre- and post-amble chopped off.
-
-	This code is encoded for size rather than absolute efficiency,
-	with a view to being able to inline as much as possible.
-
-	We only bother with direct forms (ie, vcpu in pda) of the operations
-	here; the indirect forms are better handled in C, since they're
-	generally too large to inline anyway.
+ * Asm versions of Xen pv-ops, suitable for either direct use or
+ * inlining.  The inline versions are the same as the direct-use
+ * versions, with the pre- and post-amble chopped off.
+ *
+ * This code is encoded for size rather than absolute efficiency, with
+ * a view to being able to inline as much as possible.
+ *
+ * We only bother with direct forms (ie, vcpu in pda) of the
+ * operations here; the indirect forms are better handled in C, since
+ * they're generally too large to inline anyway.
  */
 
 #include <asm/errno.h>
@@ -21,25 +21,25 @@
 #include "xen-asm.h"
 
 ENTRY(xen_adjust_exception_frame)
-	mov 8+0(%rsp),%rcx
-	mov 8+8(%rsp),%r11
+	mov 8+0(%rsp), %rcx
+	mov 8+8(%rsp), %r11
 	ret $16
 
 hypercall_iret = hypercall_page + __HYPERVISOR_iret * 32
 /*
-	Xen64 iret frame:
-
-	ss
-	rsp
-	rflags
-	cs
-	rip		<-- standard iret frame
-
-	flags
-
-	rcx		}
-	r11		}<-- pushed by hypercall page
-rsp ->	rax		}
+ * Xen64 iret frame:
+ *
+ *	ss
+ *	rsp
+ *	rflags
+ *	cs
+ *	rip		<-- standard iret frame
+ *
+ *	flags
+ *
+ *	rcx		}
+ *	r11		}<-- pushed by hypercall page
+ * rsp->rax		}
  */
 ENTRY(xen_iret)
 	pushq $0
@@ -48,8 +48,8 @@ ENDPATCH(xen_iret)
 RELOC(xen_iret, 1b+1)
 
 /*
-	sysexit is not used for 64-bit processes, so it's
-	only ever used to return to 32-bit compat userspace.
+ * sysexit is not used for 64-bit processes, so it's only ever used to
+ * return to 32-bit compat userspace.
  */
 ENTRY(xen_sysexit)
 	pushq $__USER32_DS
@@ -64,10 +64,10 @@ ENDPATCH(xen_sysexit)
 RELOC(xen_sysexit, 1b+1)
 
 ENTRY(xen_sysret64)
-	/* We're already on the usermode stack at this point, but still
-	   with the kernel gs, so we can easily switch back */
+	/* We're already on the usermode stack at this point, but
+	 * still with the kernel gs, so we can easily switch back */
 	movq %rsp, PER_CPU_VAR(old_rsp)
-	movq PER_CPU_VAR(kernel_stack),%rsp
+	movq PER_CPU_VAR(kernel_stack), %rsp
 
 	pushq $__USER_DS
 	pushq PER_CPU_VAR(old_rsp)
@@ -81,8 +81,8 @@ ENDPATCH(xen_sysret64)
 RELOC(xen_sysret64, 1b+1)
 
 ENTRY(xen_sysret32)
-	/* We're already on the usermode stack at this point, but still
-	   with the kernel gs, so we can easily switch back */
+	/* We're already on the usermode stack at this point, but
+	 * still with the kernel gs, so we can easily switch back */
 	movq %rsp, PER_CPU_VAR(old_rsp)
 	movq PER_CPU_VAR(kernel_stack), %rsp
 
@@ -98,28 +98,27 @@ ENDPATCH(xen_sysret32)
 RELOC(xen_sysret32, 1b+1)
 
 /*
-	Xen handles syscall callbacks much like ordinary exceptions,
-	which means we have:
-	 - kernel gs
-	 - kernel rsp
-	 - an iret-like stack frame on the stack (including rcx and r11):
-		ss
-		rsp
-		rflags
-		cs
-		rip
-		r11
-	rsp->	rcx
-
-	In all the entrypoints, we undo all that to make it look
-	like a CPU-generated syscall/sysenter and jump to the normal
-	entrypoint.
+ * Xen handles syscall callbacks much like ordinary exceptions, which
+ * means we have:
+ * - kernel gs
+ * - kernel rsp
+ * - an iret-like stack frame on the stack (including rcx and r11):
+ *	ss
+ *	rsp
+ *	rflags
+ *	cs
+ *	rip
+ *	r11
+ * rsp->rcx
+ *
+ * In all the entrypoints, we undo all that to make it look like a
+ * CPU-generated syscall/sysenter and jump to the normal entrypoint.
  */
 
 .macro undo_xen_syscall
-	mov 0*8(%rsp),%rcx
-	mov 1*8(%rsp),%r11
-	mov 5*8(%rsp),%rsp
+	mov 0*8(%rsp), %rcx
+	mov 1*8(%rsp), %r11
+	mov 5*8(%rsp), %rsp
 .endm
 
 /* Normal 64-bit system call target */
@@ -146,7 +145,7 @@ ENDPROC(xen_sysenter_target)
 
 ENTRY(xen_syscall32_target)
 ENTRY(xen_sysenter_target)
-	lea 16(%rsp), %rsp	/* strip %rcx,%r11 */
+	lea 16(%rsp), %rsp	/* strip %rcx, %r11 */
 	mov $-ENOSYS, %rax
 	pushq $VGCF_in_syscall
 	jmp hypercall_iret
-- 
1.6.0.2

