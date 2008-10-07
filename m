Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYJGSbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYJGSbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbYJGSaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:30:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36076 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYJGSaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:30:04 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: [PATCH 0/4] integrity
Date: Tue,  7 Oct 2008 14:00:10 -0400
Message-Id: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset addresses a couple of concerns raised on the 
mailing list:

- Christoph Hellwig's questioned what is protecting the TPM 
  internal kernel interface from the driver being removed,
  when it is not builtin. The TPM device should be builtin
  in order to start collecting measurements at the earliest 
  possible time. When the TPM is not builtin, the internal
  TPM kernel interface now protects itself from the driver 
  being removed by incrementing the module reference count.

  The integrity-TPM-internal-kernel-interface.patch prereqs:
        TPM-update-char-dev-BKL-pushdown.patch
        TPM-num_opens-to-is_open-variable-change.patch
        TPM-rcu-locking.patch
        TPM-addition-of-pnp-remove.patch
        TPM-Fixed-tpm_release-timing.patch

- Discussion on the mailing list questioned the use of special
  magic values in userspace, concluding these values are already
  exported to userspace via statfs and their correct/incorrect
  usage is left up to the userspace application.

- Concern was raised on the lkml mailing list, about adding i_integrity
  to the inode structure.  This patch adds a comment clarifying that
  i_integrity is only included in the inode if INTEGRITY is configured.

Mimi Zohar (4):
  integrity: TPM internel kernel interface
  integrity: special fs magic
  integrity: Linux Integrity Module(LIM)
  integrity: IMA as an integrity service provider
