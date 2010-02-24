Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0BXAMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:12:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42565 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0BXAMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:12:17 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel-owner@vger.kernel.org
Subject: [Patch 0/1] Fix __d_path for lazy unmounts v2
Date: Tue, 23 Feb 2010 16:12:08 -0800
Message-Id: <1266970329-28068-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100223010413.GA31046@us.ibm.com>
References: <20100223010413.GA31046@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second iteration of the __d_path patch
Fixes                                      
* formating problem - while(dentry    
* the assignment where comparison should be used

Tests to exercise the behavior and test for regressions follows

---

#!/bin/bash

#simple script to test behavior of lazily unmounted bind mount

DIR1=`mktemp -d /tmp/foo.XXXXXXXXXX`
DIR2=`mktemp -d /tmp/test.XXXXXXXXXX`
mkdir "$DIR2/bar"
mount --bind "$DIR2" "$DIR1"
cd "$DIR1/bar"
echo "Before umount -l"
/bin/pwd
umount -l "$DIR1"
echo "After umount -l"
/bin/pwd
echo "After cd .."
cd ..
/bin/pwd

rm -rf "$DIR1" "$DIR2"

