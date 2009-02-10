Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbZBJOv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbZBJOv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZBJOvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:51:46 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:26344 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZBJOvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Pnq9XfyI7l5AwthM5/Hy/b6obsH67G8sZGLrzAr7XlIZBdQW1yKMpKPzGGo8t0saVI
         8HoW67zXYN59AUztl+S6qvu2ILBGtxD3JNa74LiJR4pURsB4/re5vgE3ETgZQ0codS4f
         bgX3IjGH7yQIDrOJC6AGRDbaeysV9XDk/+TFY=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: Fix pt_regs passed by value
Date: Tue, 10 Feb 2009 09:51:44 -0500
Message-Id: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several syscalls and one trap handler currently rely on the pt_regs
struct being passed in by value.  This causes problems with stack
protector, and can also cause problems with corruption due to tail-call
optimization.  Change them to use a pointer to the pt_regs struct
instead.

--
Brian Gerst

