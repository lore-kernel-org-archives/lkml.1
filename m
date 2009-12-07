Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbZLGLB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbZLGLB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 06:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933179AbZLGLB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 06:01:26 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43385 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810AbZLGLBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 06:01:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ClHG3AMu540gHA4ezSe3pFIw6t8Ua1AX179dvii5mtWT41/xGttlHGBeOVTl+OPqN5
         /Kx5/ripjFQD4f90rWpwzGQ2O1AzyzVyKvvZNRUGHqLnxWz4hiqCOAtlNqS2AKzO1riW
         W9b+2rB8zV57ey5ZAE3/XzN9Y0yX0Y4Vdc5V8=
Subject: Re: [PATCH v8 5/8] Loongson: YeeLoong: add hardware monitoring
 driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20091207094909.GD23088@elf.ucw.cz>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
	 <d8789fa7e97d8a170c4e2516d7ef2d2fbbe42cc6.1260082252.git.wuzhangjin@gmail.com>
	 <20091206084717.GD2766@ucw.cz> <1260147298.3126.2.camel@falcon.domain.org>
	 <20091207080446.GB23088@elf.ucw.cz>
	 <1260178870.9092.34.camel@falcon.domain.org>
	 <20091207094909.GD23088@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 07 Dec 2009 19:01:03 +0800
Message-ID: <1260183663.9092.51.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 10:49 +0100, Pavel Machek wrote:
> On Mon 2009-12-07 17:41:10, Wu Zhangjin wrote:
> > On Mon, 2009-12-07 at 09:04 +0100, Pavel Machek wrote:
> > > > > What is going on here? I thought the value is already in two's
> > > > > complement... Is the above equivalent of
> > > > > 
> > > > > 	      if (value < 0)
> > > > > 	      	 value = -value; 
> > > > > 
> > > > > ? If so, why? If not, can you add a comment?
> > > > 
> > > > Right, then, will use this instead:
> > > > 
> > > > static int get_battery_current(void)
> > > > { 
> > > > 	s16 value;
> > > > 
> > > > 	value = (ec_read(REG_BAT_CURRENT_HIGH) << 8) |
> > > > 		(ec_read(REG_BAT_CURRENT_LOW));
> > > > 
> > > > 	return abs(value);
> > > > }
> > > 
> > > That's certainly better. But... why not return signed value? Current
> > > flowing from the battery is certainly very different from current
> > > flowing into it...
> > 
> > You are totally right ;)
> > 
> > Just test it, when flowing from the battery, the value is negative, and
> > when flowing into the battery, the value is positive, so, no abs()
> > needed. thanks!
> 
> Make it return -value, then. I believe other code uses >0 values for
> discharge.
> 	

Done, but any document/standard about it?

Regards,
	Wu Zhangjin

