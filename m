Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbZEGSm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbZEGSm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZEGSmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:42:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZEGSmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:42:16 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] crypto: disallow non-approved algs in fips mode
Date: Thu, 7 May 2009 14:41:26 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.29.1-102.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071441.27093.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, nothing is preventing the use of non-approved algorithms
in fips mode. I was initially working on a patch to make it easier
for all fips-approved algs to be tested using tcrypt, and realized
the changes I was making could also be used to prevent non-approved
algs in fips mode. Any approved alg *must* have self-tests, and thus
have an entry in testmgr.c's alg_test_descs[]. By adding a fips flag
to these entries, we can simply reject all algs that don't have this
flag when in fips mode by skipping their self-tests and returning
an -EINVAL to prevent them from being loaded. So with this change, I
can

1) 'modprobe tcrypt' and have all fips approved algs self-tested, and
   *only* fips approved algs tested

2) 'modprobe md4' for example, and in fips mode, have the module load
   rejected as invalid

Patch 1/2 adds the basic infra
Patch 2/2 marks the allowed algs

-- 
Jarod Wilson
jarod@redhat.com
