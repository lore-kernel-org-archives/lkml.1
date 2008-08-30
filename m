Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYH3CFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYH3CFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 22:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYH3CFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 22:05:35 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:58680 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYH3CFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 22:05:34 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmoriss@namei.org>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       Peter Dolding <oiaohm@gmail.com>, Kenneth Goldman <kgoldman@us.ibm.com>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, Pavel Machek <pavel@suse.cz>,
       Greg KH <greg@kroah.com>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Subject: [PATCH 0/2] TPM
Date: Sat, 30 Aug 2008 00:05:02 -0300
Message-Id: <cover.1220065144.git.srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Christoph Hellwig's TPM internal kernel interface 
locking question, the following TPM changes were made: 
        - removal of the BKL calls from the TPM driver, which were
          added in the overall misc-char-dev-BKL-pushdown.patch
        - continue to protect the tpm_chip_list using the 
          driver_lock, and add an rcu to protect readers.

The TPM internal kernel interface patch will be posted as 
part of the integrity patchset.

 drivers/char/tpm/tpm.c |  285 +++++++++++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm.h |    2 +-
 2 files changed, 188 insertions(+), 99 deletions(-)

