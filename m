Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYIDQrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYIDQrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIDQrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:47:09 -0400
Received: from main.gmane.org ([80.91.229.2]:44097 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYIDQrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:47:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bs@q-leap.de>
Subject: frame unwinder patches
Date: Thu, 04 Sep 2008 18:46:52 +0200
Organization: q-leap networks GmbH
Message-ID: <g9p3du$n95$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ns1.q-leap.de
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

up to 2.6.22 the -mm series had these nice frame unwinder patches, 
which gave beautiful stack traces. Unfortunately these frame unwinder patches
seem to have been dropped :(

Anyone still maintaining updated patches?

Here is an example of a horrible stack trace, confusing my eyes

[  855.504734] Call Trace:
[  855.504734]  [<ffffffff80495af2>] ? scsi_request_fn+0x252/0x370
[  855.504734]  [<ffffffff8058b068>] io_schedule+0x28/0x40
[  855.504734]  [<ffffffff8038b876>] get_request_wait+0x96/0x110
[  855.504734]  [<ffffffff80249d40>] ? autoremove_wake_function+0x0/0x40
[  855.504734]  [<ffffffff8038bca8>] blk_get_request+0x38/0x80
[  855.504734]  [<ffffffff804950a3>] scsi_execute+0x43/0x140
[  855.504734]  [<ffffffffa00250dc>] :scsi_transport_spi:spi_execute+0x7c/0xd0
[  855.504734]  [<ffffffff8038accb>] ? blk_put_request+0x4b/0x60
[  855.504734]  [<ffffffff8049515f>] ? scsi_execute+0xff/0x140
[  855.504734]  [<ffffffffa0025b86>] :scsi_transport_spi:spi_dv_device_echo_buffer+0x1c6/0x290
[  855.504734]  [<ffffffffa00349f0>] ? :mptbase:mpt_timer_expired+0x0/0x70
[  855.504734]  [<ffffffffa0024dc3>] :scsi_transport_spi:spi_dv_retrain+0x63/0x240
[  855.504734]  [<ffffffffa00259c0>] ? :scsi_transport_spi:spi_dv_device_echo_buffer+0x0/0x290
[  855.504734]  [<ffffffffa00255f7>] :scsi_transport_spi:spi_dv_device+0x3b7/0x720
[  855.504734]  [<ffffffffa005017b>] :mptspi:mptspi_dv_device+0x6b/0x1a0
[  855.504734]  [<ffffffffa00502ce>] ? :mptspi:mptspi_dv_renegotiate_work+0x1e/0x100
[  855.504734]  [<ffffffffa005038f>] :mptspi:mptspi_dv_renegotiate_work+0xdf/0x100
[  855.504734]  [<ffffffffa00502b0>] ? :mptspi:mptspi_dv_renegotiate_work+0x0/0x100
[  855.504734]  [<ffffffffa00502b0>] ? :mptspi:mptspi_dv_renegotiate_work+0x0/0x100
[  855.504734]  [<ffffffff80245b36>] run_workqueue+0x176/0x220
[  855.504734]  [<ffffffff80246786>] worker_thread+0xa6/0x110
[  855.504734]  [<ffffffff80249d40>] ? autoremove_wake_function+0x0/0x40
[  855.504734]  [<ffffffff802466e0>] ? worker_thread+0x0/0x110
[  855.504734]  [<ffffffff8024990d>] kthread+0x4d/0x80
[  855.504734]  [<ffffffff8020c5e8>] child_rip+0xa/0x12
[  855.504734]  [<ffffffff8020bcff>] ? restore_args+0x0/0x30
[  855.504734]  [<ffffffff802498c0>] ? kthread+0x0/0x80
[  855.504734]  [<ffffffff8020c5de>] ? child_rip+0x0/0x12
[  855.504734]

Probably all the "?" lines shouldn't be printed.


Thanks,
Bernd

