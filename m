Return-Path: <linux-kernel-owner+w=401wt.eu-S1750980AbZIPEEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbZIPEEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbZIPEEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:04:04 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:64734 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZIPEED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:04:03 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 00:04:03 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=axE1/xae72jX7GTlDftL7PHI+ZSbIBb3ofZDMF5tXpwU7gLdKWFy8WC4Cjq0+ArHNH
         0/1JAZcY+B1gV2v92TxPrzl8+5oho/ZiPLtrwE8O88R8pYO5YFEZ+vDIVmFDa4asql9c
         EbD6b4qAZcgWpRCkU6CtaQILIb8dtGFQqjhWs=
MIME-Version: 1.0
In-Reply-To: <3c17e3570909152049nd801aeds3915e5889d6181f0@mail.gmail.com>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> 
	<20090915062050.GB10232@core.coreip.homeip.net> <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com> 
	<20090915162655.GB29241@core.coreip.homeip.net> <3c17e3570909152049nd801aeds3915e5889d6181f0@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 16 Sep 2009 00:03:46 -0400
Message-ID: <8bd0f97a0909152103m4848fe9ayb5835a6844ea4ca1@mail.gmail.com>
Subject: Re: [PATCH] input/keyboard: add ADP5588 QWERTY I2C Keyboard Input 
	device driver
To: Barry Song <21cnbao@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 23:49, Barry Song wrote:
> On Wed, Sep 16, 2009 at 12:26 AM, Dmitry Torokhov wrote:
>> On Tue, Sep 15, 2009 at 07:19:14AM -0400, Mike Frysinger wrote:
>>> On Tue, Sep 15, 2009 at 02:20, Dmitry Torokhov wrote:
>>> > BTW, maybe you shoudl convert to threaded IRQs here?
>>>
>>> yes, after your suggestion for the previous driver, we've been looking
>>> at all our input drivers to convert to threaded IRQs.  do we need to
>>> convert all of them before acceptance, or can we merge now and post an
>>> updated patch after ?
>>
>> It really depends on the driver. If there is a race between IRQ and the
>> WQ in the driver I will request you to fix it one way or another before
>> accepting the driver (and quite often using threaded IRQ gets rid of the
>> race). In the cases like this particular driver though I am not even
>> convinced that we need threaded IRQ. The driver is not expected to
>> generate lots of events rapidly so using keventd as it does now is
>> probably the best solution.
>
> Even though CONFIG_GENERIC_HARDIRQS is almost always "y", in case
> CONFIG_GENERIC_HARDIRQS is "n" not "y", threaded_irq will become
> original irq, drivers will not work. So is it necessary to check the
> dependence of GENERIC_HARDIRQS while using threaded_irq?

when is GENERIC_HARDIRQS not "y" ?  a quick check shows only s390/m68k
dont set it to "y" in their arch Kconfig ?  s390 isnt going to use any
of these drivers, and m68k will eventually update (m68knommu already
has !?).
-mike
