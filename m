Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399Ab0AZXVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0AZXVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177Ab0AZXVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:21:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:58415 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0AZXVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:21:12 -0500
Date: Wed, 27 Jan 2010 00:21:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux <linux-kernel@vger.kernel.org>,
       Linux USB <linux-usb@vger.kernel.org>
Subject: Re: usbhid driver: replacing resume or using a post resume
 function
In-Reply-To: <3026aa4769d53c108ee0671f2b17c668.squirrel@intranet.cs.nmsu.edu>
Message-ID: <alpine.LRH.2.00.1001270018570.15694@twin.jikos.cz>
References: <3026aa4769d53c108ee0671f2b17c668.squirrel@intranet.cs.nmsu.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010, Rick L. Vinyard, Jr. wrote:

> I was looking for an example of a hid driver that needs to customize
> resume or provides a post resume function, but couldn't find one.
> 
> I would like to implement some post resume code. In particular, the g13 on
> resume loses the backlight color, LCD image and LED state. On resume, it
> needs feature reports sent to re-establish these settings.
> 
> However, I couldn't find a way to either provide a post resume function or
> replace resume with a call to hid_resume() followed by the feature
> reports.
> 
> Any suggestions?

Current HID / USBHID code doesn't allow for that. But implementing that 
should be pretty straightforward, you can define callbacks in the 
hid_device struct and then redirect to them instead of the default ones, 
when they are initialized.

If you submit this patch together (but separately) with your Logitech G13 
driver, there shouldn't be any obstacle merging it.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

