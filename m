Return-Path: <linux-kernel-owner+w=401wt.eu-S932532AbXGKS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbXGKS1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759241AbXGKS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:27:34 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:42094 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205AbXGKS1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:27:33 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       jim.houston@ccur.com
Subject: DEFINE_IDR() and the layer cache
Date: Wed, 11 Jul 2007 20:27:29 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707112027.30490.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

while the idr discussion is still hot, there's another thing that caught my
eye recently:

As to my reading of idr.h, I have two choices of initializing a global idr:
 a) static struct idr foo; /* ... */ idr_init(&foo);
 b) static DEFINE_IDR(foo);

idr_init(), when called for the first time, sets up the layer
cache. idr_get_new() and friends expect the cache to exist. Now, what happens
if the first call to idr_get_new() targets an idr initialized using
DEFINE_IDR() before idr_init() has been called at least once? Could this
happen?

My $0.02,
  Joachim


