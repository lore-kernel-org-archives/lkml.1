Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZGGOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZGGOuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbZGGOuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:50:09 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62931 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbZGGOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YPPZlsPCsbOvVd6UpYe9POUsqqFYFbdQvfKDBzIWpgMdupw3UUrYUuRuazCW57ZdlY
         107SFw6ssSzRmie/rCJGJKhjF8e0qNZuGNqJh4qX/slSRv35ep9SbkUfdfn5yDWPNbSU
         L8sOvuoVQgmYo8Mfx/7oYCq25auGob60H/gAI=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sys_waitid() fixes
Date: Tue,  7 Jul 2009 16:50:01 +0200
Message-Id: <1246978201-10875-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches applied on top of Oleg's work in -mm (but don't interfere
with it):

do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch

Vitaly Mayatskikh (2):
  do_wait: fix sys_waitid()-specific behaviour
  Check for ->wo_info != NULL in wait_noreap_copyout()

 kernel/exit.c |   75 ++++++++++++++++++++++++++++-----------------------------
 1 files changed, 37 insertions(+), 38 deletions(-)

