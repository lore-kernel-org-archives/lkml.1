Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbZBKWyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbZBKWyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755857AbZBKWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:54:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbZBKWyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:54:04 -0500
Date: Wed, 11 Feb 2009 14:53:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net, pavel@suse.cz
Subject: Re: [PATCHv7] lis3lv02d: support both one- and two-byte sensors
Message-Id: <20090211145355.7b3d060d.akpm@linux-foundation.org>
In-Reply-To: <cb7bb73a0902111444h46be9b65pa01d4b2b9c31afe8@mail.gmail.com>
References: <49929EB8.4020802@tremplin-utc.net>
	<1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com>
	<20090211143844.27ca0d6c.akpm@linux-foundation.org>
	<cb7bb73a0902111444h46be9b65pa01d4b2b9c31afe8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Feb 2009 23:44:20 +0100
Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:

> On Wed, Feb 11, 2009 at 11:38 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 11 Feb 2009 11:06:43 +0100
> > Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
> >
> >> Sensors responding with 0x3B to WHO_AM_I only have one data register per
> >> direction, thus returning a signed byte from the position which is
> >> occupied by the MSB in sensors responding with 0x3A.
> >>
> >> Since multiple sensors share the reply to WHO_AM_I, we rename the
> >> defines to better indicate what they identify (family of single and
> >> double precision sensors).
> >>
> >> We support both kind of sensors by checking for the sensor type on init
> >> and defining appropriate data-access routines and sensor limits (for the
> >> joystick) depending on what we find.
> >>
> >
> > Which tree is this patch against?
> >
> >> --- a/drivers/hwmon/lis3lv02d.c
> >> +++ b/drivers/hwmon/lis3lv02d.c
> >> @@ -53,9 +53,6 @@
> >>   * joystick.
> >>   */
> >>
> >> -/* Maximum value our axis may get for the input device (signed 12 bits) */
> >> -#define MDPS_MAX_VAL 2048
> >> -
> >>  struct acpi_lis3lv02d adev = {
> >>       .misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
> >>  };
> >
> > Current Linus mainline has
> >
> > struct acpi_lis3lv02d adev;
> > EXPORT_SYMBOL_GPL(adev);
> >
> > here.
> 
> I based my patch on Linus' tree, plus Pavel's patch which I've been
> told is on your tree.

What is "Pavel's patch"?  Pavel writes lots of patches :(

> Is your tree available for git?

http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt

> I can try basing it on yours directly.

That shouldn't be needed.

