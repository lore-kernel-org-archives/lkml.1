Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYJCQbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYJCQbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYJCQbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:31:38 -0400
Received: from igw3.br.ibm.com ([32.104.18.26]:49290 "EHLO igw3.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYJCQbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:31:36 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, zohar@linux.vnet.ibm.com, akpm@linux-foundation.org,
       jmorris@namei.org
Subject: [PATCH 0/5] TPM: Locking update
Date: Fri,  3 Oct 2008 13:30:05 -0300
Message-Id: <cover.1223042186.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Removes unnecessary BKL from tpm.c
2) Changes the num_opens variable name to is_open since it's a binary
state
3) Implements the use of RCU to protect tpm_chip_list
4) Insert .remove function in tis_pnp_driver structure
5) Puts the timer deletion before the flushing of unfinished jobs

TPM: update char dev BKL pushdown
TPM: num_opens to is_open variable change
TPM: rcu locking
TPM: pnp remove
TPM: tpm_release() timing

 drivers/char/tpm/tpm.c     |   92 ++++++++++++++++++++-----------------------
 drivers/char/tpm/tpm.h     |    3 +-
 drivers/char/tpm/tpm_tis.c |   14 ++++++-
 3 files changed, 58 insertions(+), 51 deletions(-)

