Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZAIUx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZAIUx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZAIUxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:53:04 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:25051 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755985AbZAIUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:53:03 -0500
X-YMail-OSG: FNU4EuIVM1nDlyt2m.09XRGUKmNJcniIrizt3KEIbBvs.EgzZ22EhNDRQBbNUr_fqnY8hGNp5OdVErMUvOjapI226oRwv3BGeeKqM15eTtji1zcKtryPJLVYEXVRNHqLavCYJ3vKd52J6X8NGimgV3JOM5E1YsaAGjuQv7B5FvoaQIdVdUyi5zsY7HU-
X-Yahoo-Newman-Property: ymail-3
Subject: [LIO-Target 0/5]: Convert statically sized structures to kmem_cache
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 12:52:36 -0800
Message-Id: <1231534356.4560.996.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greeings all,

Here are a small series of patches that convert v3.0 LIO-Target data
structures that are statically sized at compile time to use struct
kmem_cache infrastructure.  Also, during the kzalloc()/free ->
kmem_cache_zalloc()/kmem_cache_free() conversion process, two memory
leaks where observed in different exception patchs, and where fixed.  

One was related to iscsi_r2t_t not being freed during
ErrorRecoveryLevel=2 for ISCSI_WRITE, and the other was
iscsi_datain_req_t for ISCSI_READ not being relased during a
NON_EXISTENT_LUN exception, immediately followed by an explict iSCSI
Logout.

These patches are against the lio-core-2.6.git tree, and tested on
v2.6.28.

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git

[PATCH 1/5] [LIO-Target]: Convert iscsi_queue_req_t to use struct kmem_cache
[PATCH 2/5] [LIO-Target]: Convert iscsi_datain_req_t to use struct kmem_cache
[PATCH 3/5] [LIO-Target]: Convert iscsi_ooo_cmdsn_t to use struct kmem_cache
[PATCH 4/5] [LIO-Target]: Convert iscsi_r2t_t to use struct kmem_cache
[PATCH 5/5] [LIO-Target]: Move iscsi_free_all_datain_reqs() to generic location

--nab

