Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZGLJHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZGLJHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZGLJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:07:33 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42757 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZGLJHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=GK0GLAEpyyL32g4vJY32zzR3l8NOUNeB9nvoMFBQuOaqHGQIx4XCtwCjGpo9cxU0f+
         3iyBarwzOOnZ1X4Idl8jSxNIT1TnT8jqqWrzJII9TGFE9PWBcMFQBMGcuXJlrBiVvNwj
         5WuzQUKsZjo6t4iFxhZUEmoDQOPbMgfgDHZQo=
Date: Sun, 12 Jul 2009 12:07:26 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig, Makefile and ifdef: mod as yes vs. no?
Message-ID: <20090712120726.59691207@daedalus.pq.iki.fi>
In-Reply-To: <20090711215343.GC31925@bombadil.infradead.org>
References: <20090712000625.7e1bffc2@daedalus.pq.iki.fi>
	<20090711215343.GC31925@bombadil.infradead.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jul 2009 17:53:43 -0400
Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Sun, Jul 12, 2009 at 12:06:25AM +0300, Pekka Paalanen wrote:
> > +#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
> >
> 
> You need to test _MODULE for the symbol too... since it's necessary to
> be able to distinguish between symbols which exist in the vmlinux, and
> symbols which require a module to be loaded.
> 
> #if defined(CONFIG_BACKLIGHT_CLASS_DEVICE) &&
> 	defined(CONFIG_BACKLIGHT_CLASS_DEVICE_MODULE)
> 
> should work.

Just || instead of &&, and yes, this is a solution for half of the problem,
thanks.

But what about the Makefile?

nouveau-y := nouveau_drv.o ...
nouveau-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += nouveau_backlight.o
obj-$(CONFIG_DRM_NOUVEAU)+= nouveau.o

With this, nouveau_backlight.o is not built if
CONFIG_BACKLIGHT_CLASS_DEVICE=m. Should I write:

nouveau-$(if $(findstring m,$(CONFIG_BACKLIGHT_CLASS_DEVICE)),y,n) += \
	nouveau_backlight.o

which to me looks ugly, or add a new Kconfig boolean option that is
selected 'if CONFIG_BACKLIGHT_CLASS_DEVICE' and use that in both Makefile
and code, or is there a canonical way to do this?

Other code seems to deal with a similar situation by #ifdef'ing the
whole c-file contents. That cannot be the preferred way, can it?


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
