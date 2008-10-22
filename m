Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYJVSMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYJVSMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYJVSMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:12:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121AbYJVSMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:12:21 -0400
Date: Wed, 22 Oct 2008 11:11:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add c2 port support.
Message-Id: <20081022111145.e5f3c632.akpm@linux-foundation.org>
In-Reply-To: <20081022174004.GB10587@kroah.com>
References: <1224683240-15439-1-git-send-email-giometti@linux.it>
	<1224683240-15439-2-git-send-email-giometti@linux.it>
	<20081022174004.GB10587@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 10:40:04 -0700 Greg KH <greg@kroah.com> wrote:

> On Wed, Oct 22, 2008 at 03:47:19PM +0200, Rodolfo Giometti wrote:
> > C2port implements a two wire serial communication protocol (bit
> > banging) designed to enable in-system programming, debugging, and
> > boundary-scan testing on low pin-count Silicon Labs devices.
> > 
> > Currently this code supports only flash programming through sysfs
> > interface but extensions shoud be easy to add.
> > 
> > Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Nice job.
> 
> Andrew, no reason why these 2 patches can't go into 2.6.28, they are
> self-contained and are new drivers.
> 
> Do you want to send them to Linus, or want me to?
> 

No opinion yet - I haven't review them.

<looks>

<wonders why c2port_idr_lock and c2port_idr are kernel-wide symbols>

<wonders what local_irq_disable() is supposed to achieve on SMP>

<spots an error-path memory leak in c2port_device_register>

<spots a stray semicolon in c2port_device_register>

<suggests that update_lock be initialised at compile-time, not at runtime>


What I haven't yet got my head around is this:

  Currently this code supports only flash programming through sysfs
  interface but extensions shoud be easy to add.

is that really what we want to use sysfs for?  As the prime interface
to a device driver (or is it a bus driver?) Didn't we used to use
device nodes for that sort of thing?

