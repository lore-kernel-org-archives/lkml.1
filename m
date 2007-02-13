Return-Path: <linux-kernel-owner+w=401wt.eu-S1751200AbXBMInG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbXBMInG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXBMInG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:43:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXBMInF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:43:05 -0500
Subject: Re: [PATCH] nanosecond filesystem support???
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Andi Kleen <ak@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0702131627210.5124@boston.corp.fedex.com>
References: <Pine.LNX.4.64.0702131627210.5124@boston.corp.fedex.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 09:42:59 +0100
Message-Id: <1171356179.12771.50.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 16:38 +0800, Jeff Chua wrote:
> On 2/12/07, Andi Kleen <ak@suse.de> wrote:
> 
> > The bigger problem is getting a file system that support it.
> 
> 
> Andi,
> 
> It seems that the part that's not returning nanosecond is in the code 
> below. I've modified it, and now stat() is returning st_mtim.tv_nsec 
> correctly.
> 
> I've tested it on ext2 and reiserfs, and both seems to be working.
> 
> 
> I don't know why "t.tv_nsec = 0;" was set in the code. Any idea?

it was there to avoid the following situation:

on disk it's still in seconds
kernel has the inode in memory, with a recently updated times
user asks for it, gets nanoseconds data
kernel evicts inode to disk
user asks again,
kernel reads from disk (in whole seconds only on disk)
kernel reports a DIFFERENT time than it did before
user program gets confused

this actually happens, make is one of those cases that get confused for
example..

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

