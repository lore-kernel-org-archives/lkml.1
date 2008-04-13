Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYDMLfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYDMLfS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 07:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756309AbYDMLfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 07:35:07 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:50815 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1756267AbYDMLfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 07:35:05 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 13 Apr 2008 21:34:53 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, joe@perches.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] printk: Remember the message level for multi-line	output
Message-ID: <20080413113453.GE29599@tull.net>
References: <20080412161733.24882.30930.stgit@marcab.local.tull.net> <20080413074007.GE20332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413074007.GE20332@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 09:40:07AM +0200, Ingo Molnar wrote:
> > Restructure the logic so the processing of the leading 3 characters of 
> > each input line is in one place, regardless whether printk_time is 
> > enabled.
> 
> hm, i'm not sure about the change itself (printks are often random, so 
> the output to the console would depend on printk ordering), but the 
> combined effect seems to be a nice cleanup that reduces the linecount:

As I understand the code, if a single call to printk() includes multiple
lines of text then those lines will be contiguous in the console output.

So if one thread does printk(KERN_ERR "aaaaa\nbbbbb\n") and another
does printk(KERN_ERR "ccccc\n") then it's not possible for the buffer
to contain "<3>aaaaa\n<3>ccccc\n<3>bbbbb\n".

On the other hand, multiple calls to printk won't necessarily have
contiguous output. This affects code like arch/blackfin/kernel/traps.c
as I described in another thread which behaves like it's the only one
doing printk().

> >  1 files changed, 27 insertions(+), 34 deletions(-)
> 
> so how about splitting it into two, first the code restructuring then a 
> small add-on that does your feature? Does this make sense to you? This 
> way, even if the feature ends up not being applied, we'll have your nice 
> cleanup :-)

Can do.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
