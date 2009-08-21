Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbZHUQl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbZHUQl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZHUQl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:41:58 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52613 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbZHUQl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:41:57 -0400
From: Andy Whitcroft <apw@canonical.com>
To: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Date: Fri, 21 Aug 2009 17:41:43 +0100
Message-Id: <1250872904-10993-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.rc3.199.g24398
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have been seeing oopses in very recent kernels when using the AOE driver.
When attempting to mount remote devices we get a warning from the kobject
layer:

  [ 2645.959090] kobject '<NULL>' (ffff880059ca22c0): tried to add
	an uninitialized object, something is seriously wrong.

Looking at the driver it seems to have always had an embedded request_queue
and it is this that is throwing the error.  It appears the intent is
tha these would be allocated and released using helpers, and the lack of
these leaves the object uninitialised and throws the error.  It is unclear
how this could ever have worked.  Anyhow the following email contains a
patch to allocate and release this request_queue via the standard helpers.
This has bene shown to fix the issue in testing.

Comments.

-apw

Andy Whitcroft (1):
  aoe: ensure we initialise the request_queue correctly

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoeblk.c |    6 +++---
 drivers/block/aoe/aoedev.c |   11 ++++++++++-
 3 files changed, 14 insertions(+), 5 deletions(-)

