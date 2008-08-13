Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbYHMN0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbYHMN0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYHMNZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:25:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40961 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752557AbYHMNZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:25:56 -0400
Date: Wed, 13 Aug 2008 14:08:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 13
Message-ID: <20080813140811.030bb766@lxorguk.ukuu.org.uk>
In-Reply-To: <s5h7ial9nvm.wl%tiwai@suse.de>
References: <20080813172452.14b0775c.sfr@canb.auug.org.au>
	<s5h7ial9nvm.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When re-starting X, it complains that it cannot change to VT7.
> Via strace, 

Does this fix it

@@ -838,6 +839,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 void __cleanup_signal(struct signal_struct *sig)
 {
 	exit_thread_group_keys(sig);
+	tty_kref_put(sig->tty);
 	kmem_cache_free(signal_cachep, sig);
 }
 
