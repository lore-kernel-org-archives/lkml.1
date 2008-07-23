Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYGWNib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYGWNib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYGWNiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:38:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3583 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751543AbYGWNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:38:22 -0400
Date: Wed, 23 Jul 2008 09:38:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Henrik Rydberg <rydberg@euromail.se>, <linux-input@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       <robfitz@273k.net>, <akpm@osdl.org>, Jiri Kosina <jikos@jikos.cz>,
       <vojtech@suse.cz>, <dmonakhov@openvz.org>, <johannes@sipsolutions.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] linux-input: bcm5974-0.57: mode-switch to atp_open,
 cleanup bug fixed
In-Reply-To: <20080722093606.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.0807230934330.22282-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008, Dmitry Torokhov wrote:

> > 4. From the state (!opened,suspended), calling open fails. Where are we?
> >
> 
> Manual suspend will surely cause open to fail. Autosuspend - if
> autoresume fails then (closed, unknown) otherwise (closed,
> autosuspended - autosuspension may not kick in immediately I think).
> 
> > 5. From the state (opened,suspended), calling resume fails. What state
> > are we in?
> > 
> 
> Screwed up ;) From the driver POV still (opened, suspended) I think.

In both of these cases, the final result depends on the reason why the
resume failed.  If it failed for administrative reasons (such as it was
an autoresume and the device had been manually suspended), then the
final state is still suspended.  But if it fails because the kernel
actually tried to resume the device and couldn't do so, then the final
state is that the device is gone, logically disconnected.

Alan Stern

