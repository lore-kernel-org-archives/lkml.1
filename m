Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbZIHPJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbZIHPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZIHPJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:09:27 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:53195 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZIHPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:09:27 -0400
From: Chris Mason <chris.mason@oracle.com>
To: jack@suse.cz, tytso@mit.edu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH RFC] Ext3 data=guarded
Date: Tue,  8 Sep 2009 11:09:53 -0400
Message-Id: <1252422595-4554-1-git-send-email-chris.mason@oracle.com>
X-Mailer: git-send-email 1.6.4.1
X-Source-IP: abhmt014.oracle.com [141.146.116.23]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AA673A1.016F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Here is a respin of the ext3 data=guarded code.  This adds a new mount option
(mount -o data=guarded) to prevent garbage in files after a crash.

The main difference from data=ordered is that data=guarded only updates
the on disk i_size after all of the data blocks are on disk.  This allows
us to avoid flushing all the data pages down to disk with every commit.

More details are in the patch emails.  It has survived some long stress tests,
but I do still need to hammer on O_DIRECT and hole filling.

Jan Kara has already picked up patch 1/2, but I'm including it here in case
anyone wants to test the code.

One important part of this patch series is that it tries to have minimal
impact on the other data modes of ext3.  So, data=ordered and data=writeback
should stay the same in performance and reliability with this code.

-chris

