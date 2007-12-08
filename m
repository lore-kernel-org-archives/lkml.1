Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXLHAVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXLHAVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 19:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXLHAV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 19:21:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbXLHAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:21:27 -0500
Date: Sat, 8 Dec 2007 01:21:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "David P. Reed" <dpreed@reed.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071208002122.GC5992@one.firstfloor.org>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <47595DB2.5080302@reed.com> <20071205111039.GA3864@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205111039.GA3864@ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 11:10:39AM +0000, Pavel Machek wrote:
> On Fri 2007-12-07 09:50:26, David P. Reed wrote:
> > My machine in question, for example, needs no waiting 
> > within CMOS_READs at all.   And I doubt any other 
> > chip/device needs waiting that isn't already provided by 
> > the bus. the i/o to port 80 is very, very odd in this 
> > context.  Actually, modern machines have potentially 
> > more serious problems with i/o ops to non-existent 
> > addresses, which may cause real bus wierdness.
> 
> I dislike outb_p clobbering port 0x80, but you are wrong here. BIOSes
> already do outs to port 0x80 for debugging reason, so these accesses
> are unlikely to do something bad.

They only do that briefly during boot though. But Linux
can do it much more often. If it's a race
or similar it might just not trigger with the BIOS.

-Andi
