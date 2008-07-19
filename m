Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYGSUgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYGSUgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 16:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYGSUfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 16:35:53 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1880 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753087AbYGSUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 16:35:53 -0400
Date: Sat, 19 Jul 2008 16:35:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Arjan van de Ven <arjan@infradead.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Re  [patch 2/3] fastboot: turn the USB hostcontroller initcalls
 into async initcalls
In-Reply-To: <48820904.2090707@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0807191627150.6459-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008, Simon Arlott wrote:

> usb/core/hub.c:
> 
> /* USB 2.0 spec, 7.1.7.3 / fig 7-29:
>  *
>  * Between connect detection and reset signaling there must be a delay
>  * of 100ms at least for debounce and power-settling.  The corresponding
>  * timer shall restart whenever the downstream port detects a disconnect.
>  *
>  * Apparently there are some bluetooth and irda-dongles and a number of
>  * low-speed devices for which this debounce period may last over a second.
>  * Not covered by the spec - but easy to deal with.
>  *
>  * This implementation uses a 1500ms total debounce timeout; if the
>  * connection isn't stable by then it returns -ETIMEDOUT.  It checks
>  * every 25ms for transient disconnects.  When the port status has been
>  * unchanged for 100ms it returns the port status.
>  */
> 
> Could it do that for all ports on the hub in parallel instead?

In fact it will, to a large extent.  The new code isn't present in
2.6.26 but it ought to be in 2.6.27-rc1.

However Arjan wasn't talking about debounce delays; he was talking 
about port-power-on delays.  A nice improvement would be to combine the 
two types of delay into one.  I'll look into it...

Alan Stern

