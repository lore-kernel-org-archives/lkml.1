Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXEBL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXEBL6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbXEBL6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:58:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:51861 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbXEBL6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:58:35 -0400
Date: Wed, 2 May 2007 13:53:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
cc: roland@redhat.com, akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: Re: [PATCH -utrace] Move utrace into task_struct
In-Reply-To: <20070502113252.GA8017@localhost.sw.ru>
Message-ID: <Pine.LNX.4.61.0705021351050.18504@yvahk01.tjqt.qr>
References: <20070502113252.GA8017@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 2 2007 15:32, Alexey Dobriyan wrote:
>--- a/include/linux/utrace.h
>+++ b/include/linux/utrace.h
>@@ -50,11 +50,30 @@ #include <linux/sched.h>
> 
> struct linux_binprm;
> struct pt_regs;
>-struct utrace;
>+struct task_struct;
> struct utrace_signal;
> struct utrace_regset;
> struct utrace_regset_view;
> 
>+#ifdef CONFIG_UTRACE
>+struct utrace {
>+	unsigned long flags;
>+	union {
>+		struct {
>+			struct task_struct *cloning;
>+			struct utrace_signal *signal;
>+		} live;
>+		struct {
>+			unsigned long flags;
>+		} exit;
>+	} u;

You can have anonymous unions. (Though that won't work with
static initializers - are there any?)


Jan
-- 
