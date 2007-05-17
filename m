Return-Path: <linux-kernel-owner+w=401wt.eu-S1762985AbXEQGTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762985AbXEQGTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXEQGSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:18:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbXEQGSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:18:55 -0400
Date: Thu, 17 May 2007 02:18:04 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Message-ID: <20070517061804.GM30166@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org> <464BAF07.9020003@cv-sv.de> <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org> <464BC67F.7080707@zytor.com> <alpine.LFD.0.98.0705162012340.3890@woody.linux-foundation.org> <464BDF58.2090907@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464BDF58.2090907@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:51:36PM -0700, H. Peter Anvin wrote:
 > Linus Torvalds wrote:
 > > 
 > > On Wed, 16 May 2007, H. Peter Anvin wrote:
 > >> It gets turned on by the code in arch/i386/kernel/cpu.  It's just that
 > >> the new code that Andi added runs during setup, i.e. in real mode, so
 > >> *way* earlier than that.
 > > 
 > > Ahh. Do we really need it that early?
 > 
 > The reason to do it early is so that we can still get a message out if
 > the CPU doesn't have the necessary features.  This is generic code and
 > not specific to CX8.
 > 
 > Since I'm rewriting the setup code in C, I have added code to enable
 > features on VIA and Transmeta CPUs (there was already code in there to
 > enable features on AMD; Intel isn't known to hide any features other
 > than PAE on 400 MHz FSB Pentium-M.)
 > 
 > I think the early feature detection makes good sense.  It's a heckuva
 > lot nicer to get a message on your screen saying that you can't boot
 > this kernel on this CPU than a crash, or an early_printk which may never
 > actually get to you.

agreed, though we'll still need something for .22 (I'm assuming your rework
isn't intended for .22)

	Dave

-- 
http://www.codemonkey.org.uk
