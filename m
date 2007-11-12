Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbXKLSSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbXKLSSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXKLSSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:18:08 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:61888 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXKLSSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:18:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=X4gX0aiqqqedL8uNWrWMiJirjFx0vMVdbzv2SsjUJyN7o2OOsnAYF9tVpEV3XYVITqJGkKu9M0pryKjbYD6lbqvQzNRiOEhl/nJuM9Dav8ZrnUoKAf1QWhtbCyIY2yZ7kf+fxd+8f+HIePvW+B6WSWGIxo+tkIhk3D3v+Cq357o=
Date: Mon, 12 Nov 2007 21:17:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] [IA32-EMU] Remove dead code
Message-ID: <20071112181758.GF7296@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>From d1e9989b50aac63f95c6c152fdc655a95aa3ab69 Mon Sep 17 00:00:00 2001
From: Cyrill V. Gorcunov <gorcunov@gmail.com>
Date: Mon, 12 Nov 2007 21:02:34 +0300
Subject: [PATCH 2/2] [IA32-EMU] Remove dead code

This patch does remove useless second time checking of fsave argument
in save_i387_ia32() routine. It's possible the compiler is doing
the same but that is much better to remove the dead code explicitly.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/ia32/fpu32.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/fpu32.c b/arch/x86/ia32/fpu32.c
index 7ab8969..d49174a 100644
--- a/arch/x86/ia32/fpu32.c
+++ b/arch/x86/ia32/fpu32.c
@@ -174,8 +174,6 @@ int save_i387_ia32(struct task_struct *tsk,
 	if (fsave)
 		return 0;
 	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
-	if (fsave)
-		return err ? -1 : 1;
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	err |= __copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
 			      sizeof(struct i387_fxsave_struct));

