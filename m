Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbZKPMTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbZKPMTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZKPMTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZKPMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:39 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 00/42] KVM updates for the 2.6.33 merge window (batch 1/2)
Date: Mon, 16 Nov 2009 14:19:01 +0200
Message-Id: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Highlights:
- improved kernel context switching speed
- better interoperation with other users of virtualization extensions
- improved irq scaling
- nested svm improvements and tracing
- improved cpufreq integration
- spin loop detection on newer hardware

Notes:
- kvm/ppc64 support will be merged through the powerpc tree
- depends on tip x86/entry branch (user return notifiers)

Alexander Graf (2):
  KVM: Activate Virtualization On Demand
  KVM: SVM: Notify nested hypervisor of lost event injections

Avi Kivity (6):
  core, x86: Add user return notifiers
  x86: Fix user return notifier build
  KVM: Don't wrap schedule() with vcpu_put()/vcpu_load()
  KVM: Don't pass kvm_run arguments
  KVM: Return -ENOTTY on unrecognized ioctls
  KVM: Move assigned device code to own file

Glauber Costa (1):
  KVM: x86: include pvclock MSRs in msrs_to_save

Gleb Natapov (9):
  KVM: Call pic_clear_isr() on pic reset to reuse logic there
  KVM: Move irq sharing information to irqchip level
  KVM: Change irq routing table to use gsi indexed array
  KVM: Maintain back mapping from irqchip/pin to gsi
  KVM: Move irq routing data structure to rcu locking
  KVM: Move irq ack notifier list to arch independent code
  KVM: Convert irq notifiers lists to RCU locking
  KVM: Move IO APIC to its own lock
  KVM: Drop kvm->irq_lock lock from irq injection path

Huang Weiyi (1):
  KVM: remove duplicated #include

Jan Kiszka (2):
  KVM: x86: Refactor guest debug IOCTL handling
  KVM: x86: Rework guest single-step flag injection and filtering

Jiri Slaby (1):
  KVM: fix lock imbalance in kvm_*_irq_source_id()

Joerg Roedel (7):
  KVM: SVM: reorganize svm_interrupt_allowed
  KVM: SVM: don't copy exit_int_info on nested vmrun
  KVM: SVM: Remove remaining occurences of rdtscll
  KVM: SVM: Move INTR vmexit out of atomic code
  KVM: SVM: Add tracepoint for nested vmrun
  KVM: SVM: Add tracepoint for nested #vmexit
  KVM: SVM: Add tracepoint for injected #vmexit

Juan Quintela (1):
  KVM: remove pre_task_link setting in save_state_to_tss16

Marcelo Tosatti (2):
  KVM: SVM: remove needless mmap_sem acquision from nested_svm_map
  KVM: x86: disable paravirt mmu reporting

Mohammed Gamal (5):
  KVM: x86 emulator: Add 'push/pop sreg' instructions
  KVM: x86 emulator: Introduce No64 decode option
  KVM: x86 emulator: Add missing decoder flags for 'or' instructions
  KVM: x86 emulator: Add pusha and popa instructions
  KVM: VMX: Enhance invalid guest state emulation

Stephen Rothwell (1):
  x86: Fix user return notifier put_cpu_var() invocation

Zachary Amsden (4):
  KVM: Separate timer intialization into an indepedent function
  KVM: Kill the confusing tsc_ref_khz and ref_freq variables
  KVM: Fix printk name error in svm.c
  KVM: Fix hotplug of CPUs

