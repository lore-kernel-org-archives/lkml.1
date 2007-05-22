Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbXEVHLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbXEVHLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXEVHKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:10:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027AbXEVHKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:10:52 -0400
Date: Tue, 22 May 2007 00:09:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clean up the contents of module.h and moduleparam.h.
Message-Id: <20070522000937.33897e3f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705210523180.30935@localhost.localdomain>
References: <Pine.LNX.4.64.0705210523180.30935@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 06:43:50 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> Shift the contents of module.h and moduleparam.h so that generic
> module content is exclusively in module.h, while parameter-specific
> content is in moduleparam.h.
> 

Causes weird runtime errors with
http://userweb.kernel.org/~akpm/config-sony.txt

[    1.347665] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
[    1.347667]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
[    1.354537] Using IPI Shortcut mode
[    1.358936] Freeing unused kernel memory: 196k freed
[    1.401304] input: PS/2 Mouse as /class/input/input3
[    1.405223] input: AlpsPS/2 ALPS GlidePoint as /class/input/input4
[    1.417894] ide_core: no version magic, tainting kernel.
[    1.421081] ide_core: module license 'unspecified' taints kernel.
[    1.424279] ide_core: Unknown symbol bus_for_each_drv
[    1.427463] ide_core: Unknown symbol bus_unregister
[    1.430503] ide_core: Unknown symbol device_release_driver
[    1.433563] ide_core: Unknown symbol add_uevent_var
[    1.436637] ide_core: Unknown symbol device_register
[    1.439647] ide_core: Unknown symbol device_attach
[    1.442519] ide_core: Unknown symbol bus_register
[    1.445282] ide_core: Unknown symbol device_unregister
[    1.453848] ide_disk: no version magic, tainting kernel.
[    1.456626] ide_disk: Unknown symbol __ide_error
[    1.459374] ide_disk: Unknown symbol ide_raw_taskfile
[    1.462103] ide_disk: Unknown symbol task_in_intr
[    1.464745] ide_disk: Unknown symbol driver_unregister
[    1.467390] ide_disk: Unknown symbol ide_map_sg
[    1.470025] ide_disk: Unknown symbol driver_register
[    1.472591] ide_disk: Unknown symbol ide_proc_unregister_driver
[    1.475093] ide_disk: Unknown symbol ide_dma_verbose
[    1.477637] ide_disk: Unknown symbol ide_proc_register_driver
[    1.480171] ide_disk: Unknown symbol generic_ide_ioctl
[    1.482663] ide_disk: Unknown symbol __ide_abort
[    1.485082] ide_disk: Unknown symbol ide_init_drive_cmd
[    1.487539] ide_disk: Unknown symbol pre_task_out_intr
[    1.489932] ide_disk: Unknown symbol proc_ide_read_geometry
[    1.492299] ide_disk: Unknown symbol ide_do_drive_cmd
[    1.494618] ide_disk: Unknown symbol ide_init_disk
[    1.496901] ide_disk: Unknown symbol ide_bus_type
[    1.499200] ide_disk: Unknown symbol ide_execute_command
[    1.501420] ide_disk: Unknown symbol task_no_data_intr
[    1.503583] ide_disk: Unknown symbol ide_get_error_location
[    1.505738] ide_disk: Unknown symbol ide_end_request
[    1.507840] ide_disk: Unknown symbol ide_setting_mtx
[    1.509903] ide_disk: Unknown symbol ide_init_sg_cmd
[    1.511942] ide_disk: Unknown symbol ide_add_setting
[    1.513971] ide_disk: Unknown symbol ide_spin_wait_hwgroup
[    1.520499] jbd: no version magic, tainting kernel.
[    1.522855] jbd: Unknown symbol round_jiffies
[    1.529780] ext3: no version magic, tainting kernel.
[    1.532032] ext3: Unknown symbol journal_get_create_access
[    1.534214] ext3: Unknown symbol journal_stop
[    1.536375] ext3: Unknown symbol journal_get_write_access
[    1.538544] ext3: Unknown symbol journal_init_dev
[    1.540818] ext3: Unknown symbol journal_errno
[    1.542907] ext3: Unknown symbol journal_restart
[    1.544992] ext3: Unknown symbol journal_dirty_metadata
[    1.547143] ext3: Unknown symbol journal_try_to_free_buffers
[    1.549274] ext3: Unknown symbol journal_dirty_data
[    1.551401] ext3: Unknown symbol journal_release_buffer
[    1.553478] ext3: Unknown symbol journal_extend
[    1.555517] ext3: Unknown symbol journal_blocks_per_page
[    1.557528] ext3: Unknown symbol journal_forget
[    1.559459] ext3: Unknown symbol journal_force_commit
[    1.561347] ext3: Unknown symbol page_cache_readahead_ondemand
[    1.563286] ext3: Unknown symbol journal_get_undo_access
[    1.565287] ext3: Unknown symbol journal_clear_err
[    1.567240] ext3: Unknown symbol journal_start
[    1.569230] ext3: Unknown symbol log_wait_commit
[    1.571155] ext3: Unknown symbol journal_abort
[    1.573058] ext3: Unknown symbol journal_check_available_features
[    1.575063] ext3: Unknown symbol journal_init_inode
[    1.576983] ext3: Unknown symbol journal_unlock_updates
[    1.578900] ext3: Unknown symbol journal_force_commit_nested
[    1.580813] ext3: Unknown symbol journal_flush
[    1.582738] ext3: Unknown symbol journal_wipe
[    1.584680] ext3: Unknown symbol journal_load
[    1.586538] ext3: Unknown symbol journal_start_commit
[    1.588416] ext3: Unknown symbol journal_destroy
[    1.590365] ext3: Unknown symbol journal_update_format
[    1.592197] ext3: Unknown symbol journal_revoke
[    1.594021] ext3: Unknown symbol journal_create
[    1.595863] ext3: Unknown symbol journal_lock_updates
[    1.597710] ext3: Unknown symbol journal_invalidatepage
[    1.645951] Kernel panic - not syncing: Attempted to kill init!
