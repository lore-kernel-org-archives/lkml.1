Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbZEMMJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbZEMMJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbZEMMIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:08:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19484 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbZEMMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:08:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aTBonJ1ObKpIOKdrgWu2MCqzyq0Lmr0tncTcdSliJw43JR8ewzjFBoI+yIMf4TP8qE
         qVe1ww+KHoV4OyhtFFFvD9U17q/OctfeQTOg90BpasELMdnPLUqupnhuuFZaWUAjxjTO
         6UFt4FzfgZG+zi+wuCtrFDv8lU8itu+XdZReU=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] More cleanups in do_wait() pathes
Date: Wed, 13 May 2009 14:08:10 +0200
Message-Id: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further cleanups of do_wait() and friends. Thanks for all your
reviews of previous patches and ideas how to make it better. I'm currently
running kernel with these patches on my laptop for 1+ day, it is still able
to boot and live 5-10 hours w/o visible issues.

Next task is to optimize a bunch of put_user() in copy_wait_opts_to_user(),
but I'd like to use Ingo's idea with put_user_try/catch. Therefore, need to
implement generic stub for architectures which does not support try/catch yet.

Vitaly Mayatskikh (3):
  Introduce "struct wait_info" to simplify wait_task*() pathes
  Replace wait_noreap_copyout() by copy_wait_opts_to_user()
  Move more common code from wait_task_*() to copy_wait_opts_to_user()

 kernel/exit.c |  127 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 61 insertions(+), 66 deletions(-)

