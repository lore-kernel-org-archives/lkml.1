Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYCAJMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYCAJMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYCAJAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 04:00:07 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:55520 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYCAI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=KKECnrxGjIhhGLx32rrMKi1b0+nLJULFphsAC+nshXDy0KvX8LMjllqJeZMb/CI/lEOOtOnDGp6rdrJmRR5OO7qoyvgaJrnnGet0J3i+lmjewNFcqLZEkNj/3PZJN5cFsbhgHrmx+GURjHlGqMJe4x6AUX+dVGWkC5vmOBHdr/M=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 00/24] ide-tape: remove pipelined mode operation
Date: Sat,  1 Mar 2008 09:58:24 +0100
Message-Id: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
CC: Jens Axboe <jens.axboe@oracle.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's the 1st draft of the pipeline removal series. As the diffstat below openly
states it, a lot of code got removed - even more than the cleanup series we did
earlier. There are several issues that we need to address concerning these
patches:

1. only compile-tested since i don't have the hardware, i.e. longer -mm brewing is
advisable the least.

2. I have left the tape->merge_stage buffer structure along with its
alloc/free functions intact for now, for simplicity. The next step would be
to go and carefully audit the code and then remove that last piece
too and use allocations on the stack instead. I guess we still expect
Jens's response on whether blk_{get,put}_request is the way to go here.

Jens?

3. After applying those we're moving into the direction of a lightweight
ide-tape driver so the stanza for its removal in
Documentation/feature-removal-schedule.txt becomes incorrect.

4. ... (i'm sure you're gonna have some more :))

 Documentation/ide/ide-tape.txt |  211 +++------
 drivers/ide/ide-tape.c         | 1032 +++-------------------------------------
 2 files changed, 134 insertions(+), 1109 deletions(-)
