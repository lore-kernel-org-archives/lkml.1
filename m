Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbZEKKNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbZEKKNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbZEKKNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:13:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:38035 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068AbZEKKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vU/tiCbFjTKo8lZ6tJHXXBO1SRY8lUBrVUSjqVGlDutRKjTmF93MgUCWLI5shuGSdD
         FZ9NUE+E4+5RXtFo8xjdelD7tle1ZPHqxmYisenuxRuDfZ8B4U7uppB+t5vXRp0zrUj1
         MzY49oOYK7s3ItTe471CuxEDEsaPCftGSqCF8=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] wait_task_* cleanups
Date: Mon, 11 May 2009 12:12:39 +0200
Message-Id: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com>
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
  Use wait_copyout() in wait_task_stopped()
  Use wait_copyout() in do_wait()
  Use wait_copyout() in wait_task_zombie()
  Use wait_copyout() in wait_task_continued()

 kernel/exit.c |  136 +++++++++++++++++++-------------------------------------
 1 files changed, 46 insertions(+), 90 deletions(-)

