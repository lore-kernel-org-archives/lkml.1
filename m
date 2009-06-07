Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZFGKAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZFGKAe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZFGKA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:00:27 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62725 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZFGKA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:00:26 -0400
To: avi@redhat.com
Cc: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <4A2B7A79.4060600@redhat.com>
	<200906071747.FFJ57396.MSOOQFVHtFOJLF@I-love.SAKURA.ne.jp>
	<4A2B8201.8050904@redhat.com>
	<200906071839.DFB51529.JFHLOFtMFOSVQO@I-love.SAKURA.ne.jp>
	<4A2B8B22.3020602@redhat.com>
In-Reply-To: <4A2B8B22.3020602@redhat.com>
Message-Id: <200906071900.GED43277.OtJOQFOFSMHVFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 7 Jun 2009 19:00:28 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> I can eliminate _tmp by using lahf/sahf, but it's not going to be a 
> trivial patch.

I don't know what's happening here.

If I comment out (_dst).bytes == 2 , it compiles.
The problem happens only "w" + "unsigned short" case.

# diff -urp arch/x86/kvm/x86_emulate.c~ arch/x86/kvm/x86_emulate.c
--- arch/x86/kvm/x86_emulate.c~ 2009-06-03 12:07:25.000000000 +0900
+++ arch/x86/kvm/x86_emulate.c  2009-06-07 17:52:05.591542272 +0900
@@ -461,8 +461,8 @@ static u32 group2_table[] = {
        do {                                                                    \
                switch ((_dst).bytes) {                                         \
                case 2:                                                         \
-                       __emulate_2op_cl(_op, _cl, _src, _dst, _eflags,         \
-                                               "w", unsigned short);           \
+                       /* __emulate_2op_cl(_op, _cl, _src, _dst, _eflags,      \
+                          "w", unsigned short); */             \
                        break;                                                  \
                case 4:                                                         \
                        __emulate_2op_cl(_op, _cl, _src, _dst, _eflags,         \
