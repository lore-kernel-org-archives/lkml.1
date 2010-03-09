Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab0CIRTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:19:12 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43931 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CIRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=NPrO1epbVuuoF6XIpLKq/2lAWvUAcCODQuO159lSYBZX5GnrMrjC9Sw/0FayTrqwrf
         rrMkprdzqwe4MwtMggdjeW+lg6iftBLUldzHl1zUN0W0X00wzcaZwrydcEeG2OT4KuNd
         lJCWiA+1f4vm0akvK/cKZsyngq+5t330QcAHI=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Greg KH <gregkh@suse.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 0/3] Workaround the Out-of-order Issue of Loongson-2F
Date: Wed, 10 Mar 2010 01:12:30 +0800
Message-Id: <cover.1268153722.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

As the Chapter 15: "Errata: Issue of Out-of-order in loongson"[1] shows, to
workaround the Issue of Loongson-2F，We need to do:

  o When switching from user model to kernel model, you should flush the branch
  target history such as BTB and RAS.
 
  o Doing some tricks to the indirect branch target to make sure that the
  indirect branch target can not be in the I/O region.

This patchset applied the above methods and for the binutils patch[3] have been
merged into binutils 2.20.1, so, it's time to upstream this patchset now.
without this patch, the machines will hang when the instruction sequence hit
the Out-of-order Issue of Loongson-2F, therefore, this patchset is very urgent
for both 2.6.33 and 2.6.34.

[1] Chinese Version: http://www.loongson.cn/uploadfile/file/20080821113149.pdf
[2] English Version of Chapter 15:
http://groups.google.com.hk/group/loongson-dev/msg/e0d2e220958f10a6?dmode=source
[3] http://sourceware.org/ml/binutils/2009-11/msg00387.html 

Regards,
 	Wu Zhangjin

Wu Zhangjin (3):
  Loongson-2F: Flush the branch target history such as BTB and RAS
  Loongson-2F: Enable fixups of binutils 2.20.1
  Loongson-2F: Fixup of problems introduced by -mfix-loongson2f-jump of
    binutils 2.20.1

 arch/mips/Makefile                 |    4 +++-
 arch/mips/include/asm/stackframe.h |   19 +++++++++++++++++++
 arch/mips/loongson/common/reset.c  |   12 +++++++++++-
 3 files changed, 33 insertions(+), 2 deletions(-)

