Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYC3Wg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYC3Wg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 18:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYC3WgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 18:36:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbYC3WgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 18:36:19 -0400
Date: Sun, 30 Mar 2008 15:35:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when getting
 disconnected
In-Reply-To: <20080330222228.GA2419@kroah.com>
Message-ID: <alpine.LFD.1.00.0803301532120.14670@woody.linux-foundation.org>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org> <20080330222228.GA2419@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 30 Mar 2008, Greg KH wrote:
> 
> I haven't heard of the opposite happening.  Anything that I can try to
> test for here, I have a lot of removable input devices to test with.

Ahh, you weren't cc'd earlier, and may have missed the discussion. It's on 
Linux-kernel in the thread called "Oops/Warning report for the week of 
March 28th 2008"

Johannes says this triggers for him:

	On the other hand, it should be easily reproducible by anyone else with
	the same trick, here's what I do:
	
	 * configure X to use /dev/input/event* devices
	 * in an xterm, do something like
	      rmmod usbhid ; modprobe usbhid
	 * switch to a VT
	 * watch kernel crash as X releases the grab on the event device

and I haven't tried it because none of my normal machines use modules, and 
I was lazy and really hoping somebody else who actually knows the device 
and input layers would take a peek.

		Linus


