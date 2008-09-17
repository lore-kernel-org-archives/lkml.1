Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYIQVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYIQVSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIQVSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:18:30 -0400
Received: from main.gmane.org ([80.91.229.2]:34395 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbYIQVS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:18:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: How how latent should non-preemptive scheduling be?
Date: Wed, 17 Sep 2008 22:18:18 +0100
Message-ID: <48D1741A.7010508@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Ingo Molnar <mingo@elte.hu>
X-Gmane-NNTP-Posting-Host: 87.112.19.134.plusnet.ptn-ag1.dyn.plus.net
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an EeePC 900 (Intel Celeron 900Mhz) and it seems to be skipping 
while playing sound through various desktop apps with a 2.6.27rc6 
kernel. It is running off an SD card which really shows up slow writes 
but the sound is seemingly skipping even when ext3 is not being used. 
When look at latencytop I often see results similar to this:

> Cause                                                Maximum     Percentage
> Scheduler: waiting for cpu                        247.2 msec         64.6 %
> futex_wait do_futex sys_futex sysenter_do_call      5.0 msec         24.8 %
> do_select core_sys_select sys_select sysenter_do_c  4.7 msec          0.7 %
> do_sys_poll sys_poll sysenter_do_call               4.5 msec          5.6 %
> do_sys_poll sys_ppoll sysenter_do_call              4.2 msec          1.7 %
> rt_mutex_timed_lock futex_lock_pi do_futex sys_fut  3.5 msec          0.5 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_re  1.9 msec          1.3 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.4 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.5 %
> on acpi_ex_field_datum_io acpi_ex_extract_from_field acpi_ex_read_data_from_field acpi_ex_resolve_node_to_value acpi_ex_resolve_to_va
> lue
> 
> 
> 
> Process rhythmbox (5694)                   Total: 358.4 msec                                                                         
> Scheduler: waiting for cpu                        221.8 msec         69.9 %
> futex_wait do_futex sys_futex sysenter_do_call      4.5 msec         26.3 %
> do_sys_poll sys_poll sysenter_do_call               3.8 msec          3.2 %
> do_select core_sys_select sys_select sysenter_do_c  1.0 msec          0.4 %
> rt_mutex_timed_lock futex_lock_pi do_futex sys_fut  0.2 msec          0.1 %


> Cause                                                Maximum     Percentage
> Scheduler: waiting for cpu                        234.8 msec         31.1 %
> futex_wait do_futex sys_futex sysenter_do_call      5.0 msec         34.4 %
> do_select core_sys_select sys_select sysenter_do_c  5.0 msec         10.3 %
> do_sys_poll sys_ppoll sysenter_do_call              5.0 msec          6.2 %
> do_sys_poll sys_poll sysenter_do_call               5.0 msec         16.4 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_re  1.9 msec          0.9 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.3 %
> msleep acpi_ec_wait acpi_ec_transaction acpi_ec_bu  1.9 msec          0.3 %
> blk_execute_rq scsi_execute scsi_execute_req scsi_  1.0 msec          0.0 %
> 
> 
> Process firefox-bin (5756)                 Total: 482.2 msec                                                                         
> Scheduler: waiting for cpu                        234.8 msec         95.5 %
> do_sys_poll sys_poll sysenter_do_call               4.1 msec          3.5 %
> futex_wait do_futex sys_futex sysenter_do_call      3.9 msec          1.0 %
> do_select core_sys_select sys_select sysenter_do_c  0.2 msec          0.0 %

top seems to show that there is CPU time still available. The kernel is 
compiled with voluntary preemption, dynticks and a HZ of 1000.

Is the scheduler waiting for CPU anything to do with the skips? If so 
what sort of maximum should I be expecting? If you are listing to music 
is it expected that you have preemption on? Would preemption even help?

