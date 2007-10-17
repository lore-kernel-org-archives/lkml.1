Return-Path: <linux-kernel-owner+w=401wt.eu-S936366AbXJQCli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366AbXJQCli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761055AbXJQCla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:41:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:31625 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760881AbXJQCl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:41:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,286,1188802800"; 
   d="scan'208";a="175924521"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Date: Tue, 16 Oct 2007 19:40:05 -0700
User-Agent: KMail/1.9.7
Cc: Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davej@redhat.com
References: <1192481110-9299-1-git-send-email-katzj@redhat.com> <200710160149.56649.jesse.barnes@intel.com> <20071016091857.GD15293@khazad-dum.debian.net>
In-Reply-To: <20071016091857.GD15293@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710161940.05785.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 16, 2007 2:18 am Henrique de Moraes Holschuh wrote:
> On Tue, 16 Oct 2007, Jesse Barnes wrote:
> > On Tuesday, October 16, 2007 1:36 am Henrique de Moraes Holschuh 
wrote:
> > > You want ACPI video to just pass the messages to userspace when
> > > X.org is driving the backlight?  Fine with me.  That *still*
> > > doesn't make it right to get these messages as hot key presses
> > > over the input layer through the thinkpad-acpi driver.  So the
> > > NAK stands.  Any changes should be done to the ACPI video driver
> > > in this case.
> >
> > So is this really the direction that input is going?  Last time I
> > talked with Dmitry, he seemed ok with adding input events for ACPI
> > and other firmware hotkeys...
>
> Last time the issue was brought up (and I do believe it was because
> of thinkpad-acpi :-) ), he made it clear that any events you are to
> act upon are fine in input, but events that are just notifications
> (i.e. the firmware already did the action) are not.

Ah yeah, I agree with that.  Regular events should be uevents or 
something, not input events.  Actual keyboard keys though (whether they 
generate firmware event messages or actual scancodes) should probably 
go through the input layer.  I thought that's what Jeremy's patch was 
doing, maybe I didn't look closely enough.

Jesse
