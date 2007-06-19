Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXFSVhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXFSVhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXFSVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:36:56 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:48683 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXFSVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:36:55 -0400
Subject: Re: [PATCH RT] disable preemption on running show all regs.
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
In-Reply-To: <1182286634.18168.48.camel@imap.mvista.com>
References: <1182284276.15228.25.camel@localhost.localdomain>
	 <1182286634.18168.48.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 17:36:01 -0400
Message-Id: <1182288961.15228.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 13:57 -0700, Daniel Walker wrote:

> Looks like you have a whitespace issue here.. Should be tabs, not
> spaces.


Bah, there's a "/* -*- linux-c -*- " at the top of that file that's
messing up with my emacs!

Is this better :-p

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21.5-rt15/drivers/char/sysrq.c
===================================================================
--- linux-2.6.21.5-rt15.orig/drivers/char/sysrq.c
+++ linux-2.6.21.5-rt15/drivers/char/sysrq.c
@@ -213,7 +213,9 @@ static struct sysrq_key_op sysrq_showreg
 
 static void sysrq_handle_showallregs(int key, struct tty_struct *tty)
 {
+	preempt_disable();
 	nmi_show_all_regs();
+	preempt_enable();
 }
 
 static struct sysrq_key_op sysrq_showallregs_op = {


