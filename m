Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbXJWKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbXJWKKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXJWKKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:10:13 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:58273 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbXJWKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:10:11 -0400
Date: Tue, 23 Oct 2007 13:10:07 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] oProfile: oops when profile_pc() return ~0LU
Message-ID: <20071023101007.3y62tufa6yxrqk4w@m.safari.iki.fi>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Philippe Elie <phil.el@wanadoo.fr>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20071021120842.GA2886@zaniah> <alpine.LFD.0.999.0710221936130.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0710221936130.30120@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-10-15)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 19:38:10 -0700, Linus Torvalds wrote:
> 
> This set of two patches look ok by me, but I'd like sign-offs.. Also, were 
> they tested and found to fix the problem by Sami?
> 
> 		Linus

The previous patch I tested by Philippe, oprof-fix-profile_pc-use.patch,
worked ok, but with this latest patch oprofiled aborts.
But kernel does not oops or print msgs.

(gdb) bt
#0  0x00007f68d66fee65 in raise () from /lib64/libc.so.6
#1  0x00007f68d6700910 in abort () from /lib64/libc.so.6
#2  0x00007f68d7053974 in code_unknown (trans=0x7fff5bcd1c60) at opd_trans.c:140
#3  0x00007f68d7053eff in opd_process_samples (buffer=0x7f68d6ef3010 "��������\002", count=99349) at opd_trans.c:362
#4  0x00007f68d7050408 in opd_do_samples (opd_buf=0x7f68d6ef3010 "��������\002", count=794792) at init.c:131
#5  0x00007f68d70504e9 in opd_do_read (buf=0x7f68d6ef3010 "��������\002", size=1048576) at init.c:181
#6  0x00007f68d70506ca in opd_26_start () at init.c:265
#7  0x00007f68d7051468 in main (argc=9, argv=0x7fff5bcd1e98) at oprofiled.c:501

(gdb) frame 2
#2  0x00007f68d7053974 in code_unknown (trans=0x7fff5bcd1c60) at opd_trans.c:140
140             abort();

(gdb) p *trans
$1 = {buffer = 0x7f68d6ef3c38 "�)\200����", remaining = 98960, tracing = TRACING_OFF, current = 0x7f68d89dd010, last = 0x7f68d89dd010, anon = 0x0, 
  last_anon = 0x0, cookie = 18446604436320244048, app_cookie = 18446604436320244048, pc = 18446744071568019675, last_pc = 18446744071568019675, 
  event = 5, in_kernel = 1, cpu = 1, tid = 10074, tgid = 10074, embedded_offset = 18446744073709551615}
(gdb) 

-- 
Do what you love because life is too short for anything else.

