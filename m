Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYHQRYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYHQRYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYHQRXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:23:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:33388 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYHQRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=CmgH45mxHI6HmcU16iPwkvQ84JKztlWO5jmRS0Agvacqvh/Mure12iYYYyVXeYvR4M
         dSxN8VWSBkpwRZMloX3p6kEsKoKp2k6VXZQe6iICQSZljgNB0Sm/8mdRwJpgXqwvrPg2
         GCxYodztvzgGiyHHLofHPaj8E+1s/uW54lP+w=
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/5] ide debugging macros
Date: Sun, 17 Aug 2008 19:23:41 +0200
Message-Id: <1218993826-4571-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's something i've been wanting to do for a long time: debugging macros. The
reason for it is that i got tired of adding debug printk's everytime i'm testing
something so here we go.

The debugging macro is similar to the old ones but is one for all drivers
(currently only ide-floppy), is nice on branch prediction and is controlled by a
drive->debug_mask switch which is a module parameter and as such can be set at
module load time, of course. I've been thinking of adding also a sysfs attribute
too but can't seem to find quite the justification for it so no sysfs for now :)

In addition, one can still optimize away all the debug calls in the old manner
and i'm sure those will be removed completely too when ide generic conversion is
done.

Please tell me what you think, what can be changed/improved and after we've
figured out the details I'll do the other drivers too.

Thanks.

 drivers/ide/ide-cd.c     |   17 ++---
 drivers/ide/ide-floppy.c |  168 +++++++++++++++++++++++++---------------------
 drivers/ide/ide-tape.c   |   23 ++----
 include/linux/ide.h      |   31 ++++++++-
 4 files changed, 135 insertions(+), 104 deletions(-)
