Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbZFONFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbZFONFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZFONEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:04:55 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:47785 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZFONEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=EsWDXi3uWSSEdbcBNjKCbst+KVcCoDJeaZUuhW6Z+hCReduik047BO7r8zwMPHavo3
         woLrN0FsUAj3xWJW1Wp1b6hgmMyKIshgt7PK/nzeQ8sQ5x+HIT2st5wKj/QjqmdQjo5v
         f0v7WoPdOHLVF3z+CPn8U8Qtkxn6ePSbzeC4o=
From: Florian Fainelli <florian@openwrt.org>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB
Date: Mon, 15 Jun 2009 15:04:50 +0200
User-Agent: KMail/1.9.9
Cc: Alek Du <alek.du@intel.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com> <20090615125146.GC19873@fluff.org.uk>
In-Reply-To: <20090615125146.GC19873@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906151504.51934.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Monday 15 June 2009 14:51:46 Ben Dooks, vous avez écrit :
> On Mon, Jun 15, 2009 at 05:15:02PM +0800, Alek Du wrote:
> > >From 7a76916ccea4a376a260ea67fbc79ac4d958757f Mon Sep 17 00:00:00 2001
> >
> > From: Alek Du <alek.du@intel.com>
> > Date: Fri, 8 May 2009 09:46:49 +0800
> > Subject: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and
> > gpio_alt_func features to GPIOLIB
> >
> > Add some more functions to GPIOLIB, they are:
> > * gpio_detect is to set GPIO interrupt triggering method (edge, level,
> > high, low, etc.)

The name does not seem to reflect what it does, what about gpio_set_type or 
gpio_set_int_type for instance ?

>
> This is the wrong way of doing it, there is as a definit set_type
> method in the irq_chip structure which should be used to alter the
> way the IRQ is triggered.

I would expect your architecture IRQ handler to have a set_type callback for 
the GPIO lines capables of generating an interrupt. See how we have beeing 
doing it for rb532 for instance: 
http://www.linux-mips.org/git?p=linux-queue.git;a=blob;f=arch/mips/rb532/irq.c;h=f07882029a90d3d155c17b462812c2936229458c;hb=HEAD#l173
