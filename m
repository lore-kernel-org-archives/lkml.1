Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbYBELVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbYBELVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYBELV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:21:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:54524 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYBELV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:21:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=hS0ueoMwV0Xx3R4c1bTv+MFuNdeCdUbT6A3CIutOez8HpwPRN5ndkypOuq66c1yPgwvZ7StKPHnSk2NrcLwM0hc0vPNpzrhj4RSTwUiFnhx+9uMhTzQ9aSD6rXpuK7rTkeHDeEacYnhmt4p9U3HovI1+GXxhYX/iA7F6ztDpZ90=
Date: Tue, 5 Feb 2008 12:21:27 +0100
To: Ben Dooks <ben@fluff.org>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions regarding mfd drivers
Message-Id: <20080205122127.63846543.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080204230155.GD27399@fluff.org.uk>
References: <20080204123714.4be6e10c.Kristoffer.ericson@gmail.com>
	<20080204230155.GD27399@fluff.org.uk>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 23:01:55 +0000
Ben Dooks <ben@fluff.org> wrote:

> On Mon, Feb 04, 2008 at 12:37:14PM +0100, Kristoffer Ericson wrote:
> > Greetings,
> > 
> > Trying to wrap my head around sm501. From what I can tell an mfd driver is a "master" driver that takes control of all
> > memory and io areas. It then hands out areas of those to drivers. Anywhere near correct?
> 
> Yes, it is the central management for these, but also ensures that any
> of the sub-drivers have properly locked access to the clocks, gpio and
> other shared resources.

Oki

> 
> The mfd driver for the sm501 exports a number of functions for the
> sub drivers to use, you should be able to see what is exported easily
> by the fact they are exported with EXPORT_SYMBOL_GPL(). The header
> files should document basic functionality of this.
> 

Will take a look at that.
 
> > I can see some benefit but still hard for me to motivate. What am I missing? What will the mfd be able to do, that I lack now?
> > 
> > The sm501 driver seems way more advanced than I will need for hd64461/hd64465 anyhow, but still need to understand sm501 completely before
> > attempting to write one on my own. Anyone know any documentation aside from example drivers?
> 
> Are you trying to write your own SM501, or something else? It seems
> you are writing for something else.
>

Im trying to move the companion chip hd64461 to a more sensible location. Paul suggested building an mfd driver.
The hd64461 chipset supplies for example pcmcia and framebuffer support. Its not as advanced as the SM501.
 
> If the chip you are targetting has shared resources, such as clock
> gates, PLLs, or gpio that other drivers need to touch, then the best
> way to go is for an mfd driver to provide this functionality and have
> all the child drivers use the exported functionality.

Oki, sounds good. Thanks for info.

> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'
