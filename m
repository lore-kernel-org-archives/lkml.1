Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYK1QNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYK1QNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYK1QMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:12:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43388 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYK1QMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:12:54 -0500
Date: Fri, 28 Nov 2008 16:12:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Daniel Perzynski <daniel.perzynski@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: HP WMI laptop extras driver
Message-ID: <20081128161249.GA6865@srcf.ucam.org>
References: <28f715610811221340s5911bf20mf763f0e6990c7078@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28f715610811221340s5911bf20mf763f0e6990c7078@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 10:40:17PM +0100, Daniel Perzynski wrote:

> Nov 22 13:11:49 h3xu5 input: HP WMI hotkeys as /class/input/input9
> quickplay button -> Nov 22 13:13:10 h3xu5 HP WMI: Unknown key pressed - 22142
> quickplay dvd button  -> Nov 22 13:14:22 h3xu5 HP WMI: Unknown key pressed -
> 220e6
> quickplay TV button -> Nov 22 13:14:52 h3xu5 HP WMI: Unknown key pressed -
> 22181

Hm. I /suspect/ that these would be better handled by a quickplay button 
driver. There's a patch for that lying around - I'll try to get it 
updated.

> previous track button -> Nov 22 13:15:50 h3xu5 HP WMI: Unknown key pressed -
> 32192
> stop button -> Nov 22 13:16:15 h3xu5 HP WMI: Unknown key pressed - 32191
> play/pause button -> Nov 22 13:16:30 h3xu5 HP WMI: Unknown key pressed - 32190
> next track  button -> Nov 22 13:16:46 h3xu5 HP WMI: Unknown key pressed - 32193
> 
> 4 above buttons are working fine in x-windows

Ok, so again handling them in hp-wmi is probably not a good idea.

> As I understand wifi on/off is supported already by hp-wmi driver

Yup.

> sound mute button -> Nov 22 13:23:28 h3xu5 HP WMI: Unknown key pressed - 32190
> volume up -> Nov 22 13:24:02 h3xu5 HP WMI: Unknown key pressed - 32190
> volume down -> Nov 22 13:24:04 h3xu5 HP WMI: Unknown key pressed - 32190
> 
> above 3 are working fine in x-windows

Since they're going through the keyboard controller, we should probably 
ignore them.

> bass/treble switch button -> Nov 22 13:25:06 h3xu5 HP WMI: Unknown key pressed
> - 22199
> bass/treble up button:
> Nov 22 13:26:18 h3xu5 HP WMI: Unknown key pressed - 22197
> Nov 22 13:26:18 h3xu5 atkbd.c: Unknown key pressed (translated set 2, code 0xbe
> on isa0060/serio0).
> Nov 22 13:26:18 h3xu5 atkbd.c: Use 'setkeycodes e03e <keycode>' to make it
> known.
> bass/treble down button:
> Nov 22 13:26:21 h3xu5 HP WMI: Unknown key pressed - 22198
> Nov 22 13:26:21 h3xu5 atkbd.c: Unknown key pressed (translated set 2, code 0xbf
> on isa0060/serio0).
> Nov 22 13:26:21 h3xu5 atkbd.c: Use 'setkeycodes e03f <keycode>' to make it
> known.
> cd eject button -> Nov 22 13:26:45 h3xu5 HP WMI: Unknown key pressed - 0

Again, looks like these are going through the keyboard controller. 
Thanks for the feedback, I'll try to work out a way of avoiding printing 
the messages.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
