Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYBDXCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYBDXCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYBDXB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:01:57 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:58294 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754427AbYBDXB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:01:57 -0500
Date: Mon, 4 Feb 2008 23:01:55 +0000
From: Ben Dooks <ben@fluff.org>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions regarding mfd drivers
Message-ID: <20080204230155.GD27399@fluff.org.uk>
References: <20080204123714.4be6e10c.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204123714.4be6e10c.Kristoffer.ericson@gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 12:37:14PM +0100, Kristoffer Ericson wrote:
> Greetings,
> 
> Trying to wrap my head around sm501. From what I can tell an mfd driver is a "master" driver that takes control of all
> memory and io areas. It then hands out areas of those to drivers. Anywhere near correct?

Yes, it is the central management for these, but also ensures that any
of the sub-drivers have properly locked access to the clocks, gpio and
other shared resources.

The mfd driver for the sm501 exports a number of functions for the
sub drivers to use, you should be able to see what is exported easily
by the fact they are exported with EXPORT_SYMBOL_GPL(). The header
files should document basic functionality of this.
 
> I can see some benefit but still hard for me to motivate. What am I missing? What will the mfd be able to do, that I lack now?
> 
> The sm501 driver seems way more advanced than I will need for hd64461/hd64465 anyhow, but still need to understand sm501 completely before
> attempting to write one on my own. Anyone know any documentation aside from example drivers?

Are you trying to write your own SM501, or something else? It seems
you are writing for something else.

If the chip you are targetting has shared resources, such as clock
gates, PLLs, or gpio that other drivers need to touch, then the best
way to go is for an mfd driver to provide this functionality and have
all the child drivers use the exported functionality.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
