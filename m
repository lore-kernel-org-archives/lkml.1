Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYD2BMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYD2BMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYD2BMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:12:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57710 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYD2BMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:12:16 -0400
Date: Tue, 29 Apr 2008 02:12:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com
Subject: Re: [2.6 patch] fs/block_dev.c:I_BDEV() mustn't be inline
Message-ID: <20080429011202.GH5882@ZenIV.linux.org.uk>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153831.GC2813@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804281736230.3119@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 05:41:11PM -0700, Linus Torvalds wrote:

> There is NO WAY IN HELL this function shouldn't be inlined, and it doesn't 
> matter a whit if some users outside of this file then also want the 
> non-inlined version.

AFAICS, it's a gcc bug.  We have
extern struct block_device *I_BDEV(struct inode *inode);
followed by
inline struct block_device *I_BDEV(struct inode *inode)
{
...
}

and presence of declaration with extern within the same translation unit
means that definition we have here is an external one, per 6.7.4.  It's
perfectly legitimate and gcc has no business complaining about inline
here; moreover, example in 6.7.4(7) is essentially the same thing...
