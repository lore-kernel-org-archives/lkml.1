Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0BPMzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:55:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:45020 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab0BPMzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:55:21 -0500
Date: Tue, 16 Feb 2010 13:55:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ed Tomlinson <edt@aei.ca>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Michael Poole <mdpoole@troilus.org>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Provide a driver for the Apple Magic Mouse - opps
In-Reply-To: <201002160734.47588.edt@aei.ca>
Message-ID: <alpine.LNX.2.00.1002161351360.30967@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <201002140922.42014.edt@aei.ca> <20100215071145.GA9135@core.coreip.homeip.net> <201002160734.47588.edt@aei.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Ed Tomlinson wrote:

> > Almost... you need to do hid_hw_stop() first and only then unregister
> > input device, Otherwise if you unload the module while moving the mouse
> > it is likely to still oops.
> 
> The exit routing for the module also has a hid_hw_stop.  Is it going to cause
> problems when it gets called twice?

The routine wasn't probably meant/designed with re-entrancy in mind, but 
looking quickly at all the subsequent callpaths, I don't see why it should 
cause any problem, as skb_queue_purge(), usb_kill_urb() and usb_free_urb() 
should be safe.

Maybe we should even add test_bit() for HID_STARTED and HID_DISCONNECTED 
at the beginning of the low-level drivers' ->stop callbacks, so that we 
don't do all the magic when all the work has been already done.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
