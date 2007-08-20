Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbXHTMhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbXHTMhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbXHTMhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:37:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:43119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXHTMgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=HyJ3mzwNKYt1ZmTDGv/uqwNwVJPUuFdSkobZ0L04zgUIipxnDpT+DMchj94sT6IZnGtsEnfQALN/lOZ/ypDeOa9fprNQy6/u3M2hA3K3u/XFBTC2DcxtyNP0bp0T5ec34Dx3oRwQtkTKsYv+2M/9852X5MZIta/Rz2DUkN48Uk0=
Subject: [PATCHSET] Sysfs cleanups from Eric W. Biederman
In-Reply-To: 
X-Mailer: git-send-email
Date: Mon, 20 Aug 2007 21:36:29 +0900
Message-Id: <11876133893720-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, containers@lists.osdl.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

This is subset of Eric W. Biederman's "Sysfs cleanups & tagged
directory support" patchset[1] with the following modifications.

* fix-i_mutex-locking-in-sysfs_get_dentry patch is added at the top
  and #14-Don_t-use-lookup_one_len_kern and
  #15-vfs-Remove-lookup_one_len_kern are dropped.  This is because #14
  contained had a bug where it might created dentry/inode for an
  already deleted sysfs_dirent.  I think it's benefitial to keep
  single lookup path.

* Rewrote simplify-sysfs_get_dentry patch and
  #08-Implement-__sysfs_get_dentry,
  #09-Move-sysfs_get_dentry-below-__sysfs_get_dentry and
  #10-Rewrite-sysfs_get_dentry-in-terms-of-__sysfs_get_dentry are
  omitted as __sysfs_get_dentry() isn't used by anyone.

* #16, 19-25 are omitted as it isn't clear yet how the tagged entry
  support will end up.

* readdir simplification fixed.

* sysfs_mutex double locking fixed.

The patchset is on top of the current -gregkh.

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/564287/focus=519


