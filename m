Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbXITH1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbXITH1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbXITH0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:23292 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbXITH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=aws9xKN28loQ+ZRflhy6/WuDqZpwA4yhCzwX14TgZrcsY2smPMukHrC0GtlH7UPkH9GBL+Zj/gnXhPgOjMslpInDSD/jVixufKjnD/6G77F49B+26YzpVSZOsxvawazSZhCg7BBUfg1T1hI9iIdZDEPOq60CxJHhXbLRNdLTZ+k=
Subject: [PATCHSET 2/4] sysfs: allow suicide
In-Reply-To: 
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:26:15 +0900
Message-Id: <11902731752407-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is the second patchset of four sysfs update patchset series[1]
and to be applied on top of the first patchset[1].

Currently, sysfs files which want to kill themselves should ask
someone else (workqueue) to kill it, which is so inhumane.  This
patchset updates sysfs file implementation such that sysfs files can
commit suicide peacefully.

Global sledgehammer module unload inhibition/delay mechanism is
implemented and used to prevent premature unload while suicide is in
progress.  Suicide attempt is detected by scanning sysfs_buffers for
matching accessor.  If suicide is detected, active references the
accessor were holding are dropped early such that the suiciding node
can be deactivated without deadlock.

As active references go away early, the module basing the code the
accessor is running can go away before it finishes.  Global module
unload inhibition is used here to prevent that until accessor callback
is complete.

This patchset contains the following four patches.

 0001-module-implement-module_inhibit_unload.patch
 0002-sysfs-make-the-sysfs_addrm_cxt-removed-list-FIFO.patch
 0003-sysfs-care-free-suicide-for-sysfs-files.patch
 0004-sysfs-make-suicidal-nodes-just-do-it-directly.patch

0001 needs Rusty Russell's ack.

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/582105


