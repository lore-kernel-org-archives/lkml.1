Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbZBBRYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbZBBRYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZBBRX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:23:56 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:60304 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbZBBRXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:23:54 -0500
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, jmorris@namei.org, dave@linux.vnet.ibm.com,
       matthltc@us.ibm.com, zohar@linux.vnet.ibm.com
Subject: [PATCH 0/2] TPM: refactoring and integrity
Date: Mon,  2 Feb 2009 15:23:42 -0200
Message-Id: <cover.1233592745.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains a refactoring patch and integrity one. The first addresses Matt Helsley and Dave Hansen's comments on replacing the data[] vectors by packed structures making the code easier to read and debug and also consolidates most of the tpm_show_* functions. The second one provides an interface to read and extend PCR values, which is widely used by IMA.

This version also addresses Matt Helsley's last observation on the timeout_t structure usage to access TPM_CAP_PROP_TIS_DURATION capability, now a new structure is being used, duration_t, whose fields now match exactly as defined in the TPM specification.

Rajiv Andrade (2):
  TPM: sysfs functions consolidation
  TPM: integrity interface

 drivers/char/tpm/tpm.c |  528 ++++++++++++++++++++++--------------------------
 drivers/char/tpm/tpm.h |  142 +++++++++++++
 include/linux/tpm.h    |   35 ++++
 3 files changed, 423 insertions(+), 282 deletions(-)
 create mode 100644 include/linux/tpm.h

