Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYCTQmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYCTQmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 12:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYCTQmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 12:42:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:11649 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbYCTQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 12:42:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TXcJDR34q0PYTecdSZjlg5NGqtF+pwHP4h2ynF1OiL/DOM/8ZgmC6/1QuTi/0dgboNDSc8Yc/j1ZInq+CIVf8cIeyK12iEmO/gWjG9BUcumEnXSCcUtb9ph9D7ViOlRV+zi+uz64mfRubEQUI/GS4YEmfWZKeTKPRCiPOJRhIXo=
Message-ID: <df47b87a0803200941q7cbee10ev5a57f7cb25406896@mail.gmail.com>
Date: Thu, 20 Mar 2008 18:41:56 +0200
From: "Ioan Ionita" <opslynx@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc5-git5 KVM memory not freed
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using KVM and the qemu kvm modified to run a windows guest. I'm
allocating 900 MB to the guest. Seems that when I terminate a qemu
process, the memory that was allocated to qemu is not freed:


Mem:       2058140    1739156     318984          0     226944     425140
-/+ buffers/cache:    1087072     971068
Swap:            0          0          0

So I'm using 1GB of ram even though I've terminated qemu. If I attempt
to start qemu again, the machine locks up. No message in the logs.

Command to start qemu:
/usr/local/kvm/bin/qemu-system-x86_64 b.data -no-acpi -m 900 -net nic
-net user -hdb temp.raw -usbdevice tablet

uname -a
Linux ops-desktop 2.6.25-rc5-git5 #1 SMP PREEMPT Sat Mar 15 14:47:25
EET 2008 x86_64 GNU/Linux


Not sure whether this is a problem on the kernel side.  I don't
pretend to understand linux memory management. But it wasn't occurring
with older kernels. I'll attempt to bisect.
