Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbZA2WZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbZA2WZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbZA2WZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:25:13 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50090 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbZA2WZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:25:10 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [PATCH 0/6] integrity 
Date: Thu, 29 Jan 2009 17:23:21 -0500
Message-Id: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains the IMA integrity patches. Based on
comments on the mailing list, both the LIM ops registration,
which provides support for multiple integrity modules, and
template ops registration, which provides template support,
have been removed. As part of this change, the integrity 
hooks have been renamed to ima.

Other changes made since the last integrity posting, are based
on comments made by: Christoph Hellwig, Dave Hansen, Paul McKenney, 
Serge Hallyn, Matt Helsley, and Sukadev Bhattiprolu. Listed here  
are major changes. Additional changes are listed in the patch 
descriptions.
- added slab for integrity information(iint) associated with an inode
- added a local read and write count in iint
- lots of code refactoring 
- addressed locking, in general, and rcu-locking issues
- removed caching of measurement policy results
- cleanup of the policy parsing

New to the integrity patchset, based on Serge Hallyn and Dave
Hansen's suggestion, is a method to detect an imbalance between
the number of calls to ima_path_check() and ima_file_free(),
which could indicate that a file was accessed without first being
measured.

The integrity-tpm-internal-interface.patch will be posted separately
by Rajiv Andrade.

Mimi Zohar (6):
  integrity: IMA hooks
  integrity: IMA as an integrity service provider
  integrity: IMA display
  integrity: IMA policy
  integrity: IMA policy open
  Integrity: IMA file free imbalance
