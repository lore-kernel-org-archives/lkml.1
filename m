Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZAUQx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZAUQx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 11:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZAUQxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 11:53:18 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:58307 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZAUQxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 11:53:17 -0500
Subject: Re: introduce delayed-leds.h to reduce code duplication
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090120120400.GA15144@khazad-dum.debian.net>
References: <20090111224331.GA28010@elf.ucw.cz>
	 <20090112100500.GA31656@khazad-dum.debian.net>
	 <20090119150219.GA6463@ucw.cz>
	 <20090120120400.GA15144@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 16:54:16 +0000
Message-Id: <1232556856.5343.48.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 10:04 -0200, Henrique de Moraes Holschuh wrote:
> I don't like the loss of functionality of the private workqueue.  I kicked
> the thinkpad led handling to a private workqueue in order to never tie up
> the system-wide one with crap spinning around in the ACPI layer, etc.  In
> fact, all thinkpad-acpi deferred work is in the private workqueue for this
> reason.
> 
> This is easy enough to fix, you just need to provide both versions of the
> interface (standard workqueue, and private workqueue).  OTOH, if nowadays
> the system-wide workqueue runs tasks in parallel and there is no risk of a
> task blocking others from completely unrelated subsystems, I can ditch the
> private workqueue.
> 
> Also, if it is going to be generic, I'd suggest the usual "void *data"
> opaque type to carry information for the driver, instead of a "led number".
> 
> I didn't see any comments from Richard, but your comment about a flag seems
> to imply there was a private one?  IMHO enhancing the led class would be the
> best way to go about it, although deferred leds are simple enough that it
> doesn't matter much.

I think the best approach is to get this header working and then see how
many people can really share it. If its common enough we can add to the
core but lets see if its a useful abstraction first?

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

