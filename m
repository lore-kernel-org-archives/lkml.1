Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbXKLTma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbXKLTma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXKLTmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:42:22 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4464 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751029AbXKLTmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:42:21 -0500
Date: Mon, 12 Nov 2007 14:42:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tilman Schmidt <tilman@imap.cc>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-usb-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: power-management.txt - disconnect clarification
In-Reply-To: <20071112095535.B778111004B@xenon.ts.pxnet.com>
Message-ID: <Pine.LNX.4.44L0.0711121435180.1567-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007, Tilman Schmidt wrote:

> From: Tilman Schmidt <tilman@imap.cc>
> 
> Add a paragraph to Documentation/usb/power-management.txt about the
> interaction between suspend and disconnect.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> ---
> 
> --- linux-2.6/Documentation/usb/power-management.txt	2007-10-14 00:41:08.000000000 +0200
> +++ linux-2.6.24-rc2-work/Documentation/usb/power-management.txt	2007-11-12 10:27:30.000000000 +0100
> @@ -278,6 +278,12 @@
>  	(although the interfaces will be in the same altsettings as
>  	before the suspend).
>  
> +If the device is disconnected or powered down while it is suspended,
> +the disconnect method will be called instead of the resume or
> +reset_resume method.  This will also happen if the system is resumed
> +from hibernation, as the device could have been disconnected without
> +the system being able to detect it.
> +

I don't like the second sentence very much.  How about something like 
this instead:

+If the device is disconnected or powered down while it is suspended,
+the disconnect method will be called instead of the resume or
+reset_resume method.  This is also quite likely to happen when
+waking up from hibernation, as many systems do not maintain suspend
+current to the USB host controllers during hibernation.  (It's
+possible to work around the hibernation-forces-disconnect problem by
+using the USB-Persist facility, described in
+Documentation/usb/persist.txt.)

Alan Stern

