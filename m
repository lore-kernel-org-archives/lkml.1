Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbZLRNez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbZLRNez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZLRNeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:34:17 -0500
Received: from smtp.nokia.com ([192.100.122.233]:53467 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbZLRNeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:34:13 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Driver core: Encourage use of const attributes
Date: Fri, 18 Dec 2009 15:34:18 +0200
Message-Id: <1261143261-399-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20091218042007.GA6314@suse.de>
References: <20091218042007.GA6314@suse.de>
X-OriginalArrivalTime: 18 Dec 2009 13:33:51.0415 (UTC) FILETIME=[BC701C70:01CA7FE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I know now's probably a bad time to be mentioning const issues
but I recently a reviewed a patch where 'const' was being removed 
from a device_attribute structure, and I enquired why. The reason
was simply so that device_create_file() could be called, it taking
a non-const attribute pointer. Looking inside, all that function 
did was pass a pointer to sysfs_create_file, which itself took a
const pointer. Non-constness was not required at all.

So here I offer a small patchset which I hope will permit and 
encourage device and other attributes to be made const, and put 
in read-only sections.

These have been compile/sparse tested against arm and x86_64 targets, 
and through my usual suite of tests on the arm platform I use.

In addition to the changes in the prior RFC, I have updated the 
documentation appropriately.

Regards,
Phil
