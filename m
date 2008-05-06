Return-Path: <linux-kernel-owner+w=401wt.eu-S1765425AbYEFSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765425AbYEFSAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYEFSAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:00:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50799 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbYEFSAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:00:36 -0400
Date: Tue, 6 May 2008 11:00:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: travis@sgi.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Unify current.h
In-Reply-To: <20080506125128.GA5051@elte.hu>
Message-ID: <Pine.LNX.4.64.0805061059170.23336@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805051146210.11469@schroedinger.engr.sgi.com>
 <20080506122841.GK32591@elte.hu> <20080506125128.GA5051@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Ingo Molnar wrote:

> i suspect the __ASSEMBLY__ protections in the unified file are not wide 
> enough?

Duh. yes. The x86_64 __ASSEMBLY__ protection is no longer there. We could 
move the task_struct def back into the arch specific portion. Sigh.


---
 include/asm-x86/current.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-x86/current.h
===================================================================
--- linux-2.6.orig/include/asm-x86/current.h	2008-05-06 10:58:03.000000000 -0700
+++ linux-2.6/include/asm-x86/current.h	2008-05-06 10:58:40.000000000 -0700
@@ -1,12 +1,12 @@
 #ifndef _X86_CURRENT_H
 #define _X86_CURRENT_H
 
-struct task_struct;
-
 #ifdef CONFIG_X86_32
 #include <linux/compiler.h>
 #include <asm/percpu.h>
 
+struct task_struct;
+
 DECLARE_PER_CPU(struct task_struct *, current_task);
 static __always_inline struct task_struct *get_current(void)
 {
@@ -18,6 +18,8 @@ static __always_inline struct task_struc
 #ifndef __ASSEMBLY__
 #include <asm/pda.h>
 
+struct task_struct;
+
 static __always_inline struct task_struct *get_current(void)
 {
 	return read_pda(pcurrent);
