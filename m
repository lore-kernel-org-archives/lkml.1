Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYAPR54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYAPR54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYAPR5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:57:49 -0500
Received: from mail.queued.net ([207.210.101.209]:4154 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYAPR5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:57:48 -0500
Date: Wed, 16 Jan 2008 12:58:01 -0500
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: psmouse: fix input_dev leak in lifebook driver
Message-ID: <20080116125801.199224f3@ephemeral>
In-Reply-To: <20080115170323.ZZRA012@mailhub.coreip.homeip.net>
References: <20080112151252.193d6b52@ephemeral>
	<20080115170323.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 17:04:01 -0500
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Sat, Jan 12, 2008 at 03:12:52PM -0500, Andres Salomon wrote:
> > 
> > The lifebook driver may register a second input device, but it never
> > unregisters it.  This fixes that.
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> 
> Applied, thank you Andres.
>

Hi Dmitry,
 
There's one additional patch, I don't know if you saw it; the subject
was "check return value of input_register_device() in hil_ptr.c's init".


Also, I've found myself needing to provide my own device_attribute for
the OLPC psmouse driver; I couldn't use PSMOUSE_DEFINE_ATTR(), as its
set_helper callback calls psmouse_disable.

static DEVICE_ATTR(powered, S_IWUSR | S_IRUGO, hgpk_show_powered,
                hgpk_set_powered);

Unfortunately, in order to not be racy, hgpk_set_powered needs to
deal with psmouse_mutex.  Which method of dealing with this would
you prefer?  I could either make psmouse_mutex no longer static,
provide psmouse_mutex locking functions (declared in psmouse.h), or
put psmouse_mutex into 'struct psmouse'.  Or, if you have any other
ideas..

