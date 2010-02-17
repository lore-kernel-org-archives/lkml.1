Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab0BQTip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 14:38:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56976 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751136Ab0BQTio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 14:38:44 -0500
Date: Wed, 17 Feb 2010 14:38:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
cc: Linux <linux-kernel@vger.kernel.org>,
       Linux USB <linux-usb@vger.kernel.org>
Subject: Re: Problem with modification to hid_post_reset
In-Reply-To: <a82f528d5a1ecf9f64901ace786ef844.squirrel@intranet.cs.nmsu.edu>
Message-ID: <Pine.LNX.4.44L0.1002171437160.1260-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Feb 2010, Rick L. Vinyard, Jr. wrote:

> Following is a short patch that I've been using to add hooks before and
> after device reset. I probably won't end up needing the post_reset_finish
> hook but I have it there for testing right now.
> 
> The first hook I need so I can set a flag that is dealt with on the first
> raw event, and I need to ensure the flag is set prior to queue restart.
> 
> From what I can tell, these shouldn't cause any problems... they should be
> trivial but they are causing a kernel fault on resume from a suspend.
> 
> The enclosed patch probably has line wrapping problems. If someone wants
> to test it I'll send a more proper patch, but I thought I'd throw it out
> there and see if anyone sees anything obvious.

I agree, there doesn't seem to be anything really wrong.  See below...

> ---- G13 code ----
> 
> #define hid_get_g13data(hdev) \
> 	((struct g13_data *)(hid_get_drvdata(hdev)))
> 
> static void g13_post_reset_start(struct hid_device *hdev)
> {
> 	struct g13_data *data;
> 
> 	/* Get the underlying data value */
> 	data = hid_get_g13data(hdev);
> 	/* need_reset is declared as int */
> 	data->need_reset = 1;

Is your problem caused by data coming out NULL?

Alan Stern

