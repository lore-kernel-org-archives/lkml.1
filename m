Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYLFXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYLFXQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLFXQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:16:31 -0500
Received: from vps1.tull.net ([66.180.172.116]:56745 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752957AbYLFXQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:16:30 -0500
Date: Sun, 7 Dec 2008 10:16:26 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [RFC] Recursive printk
Message-ID: <20081206231626.GK5957@mail.local.tull.net>
References: <20081206065922.29149.63380.stgit@marcab.local.tull.net> <20081205232016.366765e2.akpm@linux-foundation.org> <1228549357.13046.618.camel@localhost> <20081206084038.GG5957@mail.local.tull.net> <1228554693.13046.624.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228554693.13046.624.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 01:11:33AM -0800, Joe Perches wrote:
> I think the question is how to output messages that use
> multiple calls to printk so they are not interleaved.

This is certainly needed e.g. for code which outputs line fragments
and expects full lines in the log, such as hex dumps. But its arguable
that that code should use its own buffer to format lines, then send
only complete lines to printk.

> Giving up printf argument verification seems too high a
> price to pay for the benefit of recursion.

I agree completely. I was hoping somebody could tell me how to include
'%v' in gcc's acceptable list, but it seems impossible. The alternative
then is to use '%pV%s' which gcc _should_ like (I haven't tested it,
but it seems reasonable) and reverse the order of the fmt and args
in the function call arguments.

Nick.
