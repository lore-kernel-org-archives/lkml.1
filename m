Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377Ab0AELK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0AELK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820Ab0AELK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:10:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab0AELKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:10:21 -0500
Message-ID: <4B431E0B.40200@redhat.com>
Date: Tue, 05 Jan 2010 19:10:03 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: airlied@redhat.com, jglisse@redhat.com, dri-devel@lists.sourceforge.net,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel paging request on 2.6.33-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

     When I perform "echo mem > /sys/power/state", I got BUG on 
rs600_gart_set_page, then suspend hangs.

     I don't have a camera to log the outputs, the call trace are:

     rs600_gart_set_page+0x31
     radeon_gart_bind
     radeon_ttm_backend
     ttm_tt_bind
     ttm_bo_handle_move_mem
     ttm_mem_evict_fist
     ttm_bo_force_list_clean
     ttm_bo_evict_vram
     ttm_suspend_kms
     radeon_pci_suspend
     pci_legacy_suspend
     pci_pm_suspend
     pm_op
     dpm_suspend
     suspend_devices_and_enter
     enter_state
     state_store
     kobj_attr_store
     sysfs_write_file
     vfs_write
     sys_write
     system_call_fastpath

     l *rs600_gart_set_page+0x31 is in writeq, maybe this is a possible 
use-after-free. Thanks.



