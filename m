Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYAMEnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYAMEnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 23:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYAMEnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 23:43:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYAMEne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 23:43:34 -0500
Date: Sat, 12 Jan 2008 20:42:48 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: tcamuso@redhat.com
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Loic Prylli <loic@myri.com>,
       Prarit Bhargava <prarit@redhat.com>,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>,
       "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>,
       Bhavana Nagendra <bnagendr@redhat.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20080112204248.29abb1dd@laptopd505.fenrus.org>
In-Reply-To: <47896B3B.2000108@redhat.com>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	<20080111204228.GP18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	<20080111211753.GR18741@parisc-linux.org>
	<alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	<20080111213803.GS18741@parisc-linux.org>
	<20080111235856.GA16079@jurassic.park.msu.ru>
	<20080112002638.GA18710@kroah.com>
	<20080112144030.GA19279@jurassic.park.msu.ru>
	<20080112094557.71f5382a@laptopd505.fenrus.org>
	<20080112214911.GA20102@jurassic.park.msu.ru>
	<20080112150120.05f93768@laptopd505.fenrus.org>
	<47895767.3090503@redhat.com>
	<20080112164006.6f6f7bc2@laptopd505.fenrus.org>
	<47896B3B.2000108@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jan 2008 20:36:59 -0500
Tony Camuso <tcamuso@redhat.com> wrote:

> Thanks, Arjan.
> 
> The problem we have been experiencing has to do with Northbridges,
> not with devices.

correct for now.
HOWEVER, and this is the point Linus has made several times:
Just about NOBODY has devices that need the extended config space. At all.
So making this opt-in for devices allows our users to boot and use
their system if they are in the majority that has no need for even getting
close to this mess.

> 
> As far as the device is concerned, after the Northbridge translates
> the config access into PCI bus cycles, the device has no idea what
> mechanism drove the Northbridge to the translation.

Wanne bet there'll be devices that screw this up? THere's devices that even screwed
up the 64-256 region after all.

> The patch I devised concerned itself with Northbridges and separated
> MMCONFIG-compliant buses from those that could not handle MMCONFIG.

THis kind of patchup has been going on for the better part of a year (well 2 years)
by now and it's STILL NOT ENOUGH, as you can see by the more patchups that have
been proposed as "alternative" to my approach.

> 
> In my humble opinion, Port IO config access is here to stay, having
> been defined as an architected mechanism in the PCI 2.1 spec.
> 
> This is most especially true for x86.
> 
> In other words, for x86, I don't think we need to worry about Port
> IO config access ever going away at all.

You're wrong there. Sad to say, but you're wrong there.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
