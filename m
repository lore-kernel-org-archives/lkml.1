Return-Path: <linux-kernel-owner+w=401wt.eu-S1763770AbXHFRPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763770AbXHFRPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757585AbXHFRPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:15:36 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:59185 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbXHFRPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:15:35 -0400
Date: Mon, 6 Aug 2007 14:15:23 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: convert mm_context_t semaphore to a mutex
Message-ID: <20070806141523.069b24b0@localhost>
In-Reply-To: <20070806152502.GA6988@elte.hu>
References: <20070803105540.4f85ae09@localhost>
	<20070806074608.GA12415@elte.hu>
	<20070806103615.4be4670f@localhost>
	<20070806152502.GA6988@elte.hu>
Organization: Mandriva
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 6 Aug 2007 17:25:02 +0200
Ingo Molnar <mingo@elte.hu> escreveu:

| 
| * Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br> wrote:
| 
| > | hm, looks good to me but i'm wondering why this was a holdout for 
| > | such a long time :-) Did you manage to test actual LDT functionality 
| > | with this patch applied?
| > 
| >  No, I didn't. The only test I did was to run the kernel with this 
| > patch applied.
| > 
| >  I'll manage to test it then. Do you have a test-case or has any 
| > suggestion?
| 
| i think try any pthread program with:
| 
|    export LD_ASSUME_KERNEL=2.4.0
| 
| should trigger the LDT code. Try stracing the code and modify_ldt calls 
| should show up.

 I couldn't run this because my libc requires 2.6 kernels.

 But I've managed to run wine with a game called 'Align-it!', and
I have the following result:

"""
~/tmp/ egrep -c 'modify_ldt' wine-strace.txt 
46
~/tmp/ 
"""

 I've checked the calls and none has failed. Not sure how good
this test is though.

 Maybe it could be more tested in -mm?

| >  Oh, btw, I forgot to 'quilt add arch/i386/mm/fault.c' [...]
| 
| heh. After a dozen of such incidents i scripted my editor command to 
| automatically do the quilt add :)

 Oh, that's a good tip.

 Thanks a lot,

-- 
Luiz Fernando N. Capitulino
