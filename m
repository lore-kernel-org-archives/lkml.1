Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYDGEqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYDGEqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYDGEpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:45:04 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:13097 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYDGEou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=F44cFhyw9Pw/ShWajFHoTBSTzU9QRYeybnGsoYjOsjeHaVYbL7W8rctpp6YEsGrO9/hgamfnsjG5com2npXOJAIZzsh1iLayStgLeabQ4V86TOHjVoYKyWLrRjhoab9XCLM1S9bNaHJdTn8WZdNe+1DcwUeKuKoHTpCsrZS97YE=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/6] ide-tape: refit tape data buffer bits/kill pipelining-v2
Date: Mon,  7 Apr 2008 06:44:58 +0200
Message-Id: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's another patchset that contains some other fixes along with the changes
you suggested. We have now a tape->merge_bh buffer which is a singly linked list
of bh's and tape->bh is a pointer within that list. The remaining pipelining
functions have been readjusted to handle the merge buffer. I guess, that was it,
pipelining is gone.

 drivers/ide/ide-tape.c |  215 ++++++++++++++++++++++--------------------------
 1 files changed, 99 insertions(+), 116 deletions(-)
