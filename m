Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbYKMDsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbYKMDsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKMDsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:48:36 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41162 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYKMDsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:48:35 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>
Subject: [PATCH 0/4] integrity
Date: Wed, 12 Nov 2008 22:47:10 -0500
Message-Id: <cover.1226547084.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux Integrity Module (LIM) Framework provides hooks
for modules to perform collection, appraisal, and storage
of system integrity measurements. One such module, IMA,
collects measurements of file data, maintains this list
in the kernel, and if available, stores (extends) the
measurements into a hardware TPM. These measurements are
collected, appraised, and stored before any access
(read or execute) to the data, so that malicious code or
data cannot remove or cover up its own measurement, to avoid
detection. If the measurements are anchored in a TPM, the
TPM can sign the measurements, for proof of integrity
to a third party, such as in enterprise client management.

Integrity measurement is complementary to LSM mandatory
access control, which can be used to protect the integrity
of system files. Integrity measurement policies can take
advantage of LSM labels in deciding what to measure and
to detect when the protection fails, with hardware strength.

This patch set addresses a couple of concerns raised on
the mailing list:

- Uses a radix tree to store integrity information
  associated with an inode, instead of extending the
  inode structure.
- Moves hooks out of vfs_permission and file_permission,
  which are deprecated.
- Fixes the template list locking.
- Updates and clarifies the integrity_audit kernel
  command line option.

Dave Safford
Mimi Zohar (4):
  integrity: TPM internel kernel interface
  integrity: Linux Integrity Module(LIM)
  integrity: IMA as an integrity service provider
  integrity: IMA radix tree
