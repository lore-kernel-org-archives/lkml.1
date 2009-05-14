Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZENQTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZENQTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZENQTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:19:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:51659 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZENQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MiYdAIOCx98nzPjiqfs1eaq6oCx9n5ED6PN6sX2J1c7TYdXz7aaNQKmFPglQ/Q5uTU
         qUkkdVksk4AVu2c4ld2/opmJBR8WdkdpCG9/bqnPNWvvSpgSEWdSMYFInA/Ojep10H7G
         qTw4uhiIYofhKCJ1DeSSnPFmvn/1KIX3mQTIw=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Josef Bacik <josef@redhat.com>
Cc: sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sys_write() should write all valid data
Date: Thu, 14 May 2009 18:18:59 +0200
Message-Id: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's user-visible misbehavour in sys_write(): when user tries to put
down to disk some data, which crosses boundary of existing memory, sys_write()
either immediately returns with EFAULT or writes first page(s).

Next 2 patches make sys_write()'s behaviour more consistent: it tries now
to write down all what it can.

Vitaly Mayatskikh (2):
  Introduce check_readable_bytes()
  Perform checks in iov_iter_fault_in_readable() with
    check_readable_bytes()

 fs/fuse/file.c          |    6 ++++--
 include/linux/pagemap.h |   35 +++++++++++++++++++++++++++++++++++
 mm/filemap.c            |   13 +++++++++----
 3 files changed, 48 insertions(+), 6 deletions(-)

