Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbZEKN1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbZEKN1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZEKN1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:27:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63486 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZEKN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U6HVQnpmi3/JZ0AnSua1pD+MnZkgdIpaZn1xlSah3xCTVYauSnVm4LVW0GeZ67lVh8
         bmBets8Z5IojIKzMHZv4cpJXR+olc6T/fgr0aWoc/t/FLHGAkpPEaZOcR01xuySOjNpl
         ijAHNfhxJMEGjJbhRhv2pdA1310kvLRwhvS40=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] wait_task_* cleanups V2
Date: Mon, 11 May 2009 15:25:49 +0200
Message-Id: <1242048349-2766-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches eliminate duplicate code for filling rusage and siginfo
structures in wait_task_*() routines. The work is based on top of recent
Oleg's changes in do_wait().

I'm running kernel with these changes on my laptop for one day, nothing
exploded (yet).

More changes to come.

Vitaly Mayatskikh (5):
  Split wait_noreap_copyout()
  Use copy_wait_opts_to_user() in wait_task_stopped()
  Use copy_wait_opts_to_user() in do_wait()
  Use copy_wait_opts_to_user() in wait_task_zombie()
  Use copy_wait_opts_to_user() in wait_task_continued()

 kernel/exit.c |  136 +++++++++++++++++++-------------------------------------
 1 files changed, 46 insertions(+), 90 deletions(-)

