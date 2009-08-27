Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbZH0Fqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbZH0Fqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbZH0Fqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:46:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47541 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZH0Fqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:46:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Aug 2009 14:44:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the newest mmotom, my S14nfslock hangs up. (x86-64/Fedora10)

On Mon, 24 Aug 2009 16:28:30 -0700
akpm@linux-foundation.org wrote:

> ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch

bisected. following 2 patches for filtering SIGCHLD cause hang (for my environ).

> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
> do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch

And, Hmm, I'm not bisected yet but..
==
[root@bluextal kamezawa]# ps -ef
UID        PID  PPID  C STIME TTY          TIME CMD


Signal 11 (SEGV) caught by ps (procps version 3.2.7).
Please send bug reports to <feedback@lists.sf.net> or <albert@users.sf.net>
==

'ps -ef' gets SEGV. still digging.

Thanks,
-Kame




> do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
> do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
> wait_consider_task-kill-parent-argument.patch
> do_wait-fix-sys_waitid-specific-behaviour.patch
> wait_noreap_copyout-check-for-wo_info-=-null.patch
> signals-introduce-do_send_sig_info-helper.patch
> signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
> fcntl-add-f_etown_ex.patch
> signals-inline-__fatal_signal_pending.patch
> signals-tracehook_notify_jctl-change.patch
> signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
> signals-introduce-tracehook_finish_jctl-helper.patch
> utrace-core.patch
> exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
> exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
> exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
> exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
> exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch
> exec-fix-set_binfmt-vs-sys_delete_module-race.patch
> cpu_hotplug-dont-affect-current-tasks-affinity.patch
> char-impi-adding-__init-macro-fix-of-__exit-macro-location-in-ipmi_poweroffc.patch
> elf-clean-up-fill_note_info.patch
> elf-clean-up-fill_note_info-fix.patch
> fdpic-ignore-the-loaders-pt_gnu_stack-when-calculating-the-stack-size.patch
> flat-use-is_err_value-helper-macro.patch
> dev-zero-avoid-repeated-access_ok-checks.patch
> fs-char_devc-remove-useless-loop.patch
> pc-fs-char_devc-remove-useless-loop-fix.patch
> cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
> mwave-fix-read-buffer-overflow.patch
> hpet-hpet-driver-periodic-timer-setup-bug-fixes.patch
> drivers-char-rio-rioctrlc-off-by-one-error-in-rioctrlc.patch
> maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch
> sysctl-remove-struct-file-argument-of-proc_handler.patch
> fork-disable-clone_parent-for-init.patch
> pidns-deny-clone_parentclone_newpid-combination.patch
> linux-futexh-place-kernel-types-behind-__kernel__.patch
> edac-mpc85xx-add-p2020ds-support.patch
> edac-mpc85xx-add-mpc83xx-support.patch
> edac-fix-resource-size-calculation.patch
> edac-i3200-memory-controller-driver.patch
> edac-i3200-memory-controller-driver-fix-offset-of-reg-in-i3200_edac-module.patch
> adfs-remove-redundant-test-on-unsigned.patch
> memstick-move-dev_dbg.patch
> aio-ifdef-fields-in-mm_struct.patch
> fs-romfs-correct-error-handling-code.patch
> drivers-vlynq-vlynqc-fix-resource-size-off-by-1-error.patch
> lzma-gzip-fix-potential-oops-when-input-data-is-truncated.patch
> include-linux-unaligned-lbe_byteshifth-fix-usage-for-compressed-kernels.patch
> lzo-add-support-for-lzo-compressed-kernels.patch
> lzo-arm-add-support-for-lzo-compressed-kernels.patch
> lzo-x86-add-support-for-lzo-compressed-kernels.patch
> lzo-add-lzo-compression-support-for-initramfs-and-old-style-initrd.patch
> task_struct-cleanup-move-binfmt-field-to-mm_struct.patch
> sound-core-pcm_timerc-use-lib-gcdc.patch
> net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
> net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
> vfs-take-2add-set_page_dirty_notag.patch
> reiser4-vfs-add-super_operationssync_inodes-2.patch
> reiser4-export-remove_from_page_cache.patch
> reiser4-export-remove_from_page_cache-fix.patch
> reiser4-export-find_get_pages.patch
> reiser4.patch
> reiser4-adjust-to-the-new-aops.patch
> reiser4-adjust-to-the-new-aops-fixup.patch
> reiser4-remove-simple_prepare_write-usage.patch
> reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
> fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch
> reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
> reiser4-update-names-of-quota-methods.patch
> reiser4-use-set_page_dirty_notag.patch
> fs-reiser4-add-parenths-around-x-y.patch
> fs-reiser4-contextc-current_is_pdflush-got-removed.patch
> make-sure-nobodys-leaking-resources.patch
> journal_add_journal_head-debug.patch
> releasing-resources-with-children.patch
> make-frame_pointer-default=y.patch
> mutex-subsystem-synchro-test-module.patch
> slab-leaks3-default-y.patch
> put_bh-debug.patch
> add-debugging-aid-for-memory-initialisation-problems.patch
> keep-track-of-network-interface-renaming.patch
> workaround-for-a-pci-restoring-bug.patch
> prio_tree-debugging-patch.patch
> single_open-seq_release-leak-diagnostics.patch
> add-a-refcount-check-in-dput.patch
> getblk-handle-2tb-devices.patch
> getblk-handle-2tb-devices-fix.patch
> undeprecate-pci_find_device.patch
> notify_change-callers-must-hold-i_mutex.patch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

