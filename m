Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYDNLDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYDNLDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYDNLDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:03:30 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:33296 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752126AbYDNLDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:03:30 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Mon, 14 Apr 2008 21:03:16 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       joe@perches.com
Subject: Re: [PATCH 2/2] printk: Remember the message level for multi-line	output
Message-ID: <20080414110316.GJ29599@tull.net>
References: <20080413115152.29086.37845.stgit@marcab.local.tull.net> <20080413122735.31769.17716.stgit@marcab.local.tull.net> <20080414080351.GL16163@elte.hu> <20080414101200.GH29599@tull.net> <20080414102634.GA20649@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414102634.GA20649@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 12:26:34PM +0200, Ingo Molnar wrote:
> * Nick Andrew <nick@nick-andrew.net> wrote:
> > Yes, quite. The state of whether we're inside a line is retained 
> > across calls to printk (from anywhere in the system) - this allows 
> > code like this to usually do what you expect:
> > 
> > 	printk(KERN_ERR "Error:");
> > 	for (i = 0; i < 16; ++i) {
> > 		printk("  %02x", i);
> > 	}
> > 	printk("\n");
> > 
> > But in your example the first printk call contains a \n at the end of 
> > the line and so upon entry to the second printk call the function 
> > knows a new line is beginning.
> 
> ok - i think your change is a good one.

Thank you.

> btw., we could also start emitting debug warnings that the printk is not 
> conform. Something like:
> 
>   "INFO: the previous printk was done without a KERN_ annotation"

There are 20k+ instances of this in the codebase; we don't need a
runtime message to find them. If you annotate them all, that will
add up to 60k to the binary size. Perhaps it's best to retain the
default support.

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
