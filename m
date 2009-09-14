Return-Path: <linux-kernel-owner+w=401wt.eu-S932435AbZINSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbZINSKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZINSKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:10:13 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:38122 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbZINSKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OrWR1+th/8xnS7Q2SBNyuGRreHZ/vaRG+McZbVzSppqmUGRdmvy8f1UyOszoaRXk5N
         WxDJH74zJAN0nqZzT75i3NkTA1iVx+peNgUOL9VbYdCCC3b9e4dPQzpqG/2Gzativ/d5
         GV0jP8ZxUalPlU4/eJVloFMvBACtuikI3afng=
MIME-Version: 1.0
In-Reply-To: <200909141049.50705.dmitry.torokhov@gmail.com>
References: <1252911864-19233-1-git-send-email-vapier@gentoo.org> 
	<1252950003-9451-1-git-send-email-vapier@gentoo.org> <200909141049.50705.dmitry.torokhov@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Sep 2009 14:02:18 -0400
Message-ID: <8bd0f97a0909141102l5fa309f4ua1bedd0f1ac99295@mail.gmail.com>
Subject: Re: [PATCH v3] input/keyboard: new OpenCores Keyboard Controller 
	driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 13:49, Dmitry Torokhov wrote:
> On Monday 14 September 2009 10:40:03 am Mike Frysinger wrote:
>> +struct opencores_kbd {
>> +     struct input_dev *input;
>> +     struct resource *addr_res;
>> +     struct resource *irq_res;
>> +     unsigned short *keycode;
>> +};
>
> Why do we allocate keycode table separately form the main structure?

the double alloc looked a little funny, but i didnt dive deep into the
details.  but as you point this out, it seems to make sense to me.
any problems with that change Javier ?

i.e. we do:
struct ... { ... unsigned short keycode[NUM_KEYS]; }
rather than doing two calls to kmalloc

> I think I still have some reservations with the notion that we can just
> have exact "scancode" - KEY_* mapping and hardware producers will adjust
> the hardware to follow the deriver but I guess it's OK...

considering this is a piece of "hardware" implemented in FPGAs, i
think it's ok too.  if someone really needs more flexibility, then
they're free to extend the driver and submit a patch :).
-mike
