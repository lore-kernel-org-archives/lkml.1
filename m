Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZIPDtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZIPDtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZIPDtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:49:49 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:56344 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZIPDts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rABC8Trxr15+M9PJkTWE+Tcx9nG/vj/vrLV5+XRLQ9S3f7athLMFdp6xMa2HnuOifv
         pEshYXeLkLjmH8jNcVwcxNlLo2gdq9prgcN4340GIblFMj70+9uT9+jaxZNPWmpqJTxX
         Ub6Hsf+L7XAqFbawIEVHDUMnVPm7DOISnkvJQ=
MIME-Version: 1.0
In-Reply-To: <20090915162655.GB29241@core.coreip.homeip.net>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> 
	<20090915062050.GB10232@core.coreip.homeip.net> <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com> 
	<20090915162655.GB29241@core.coreip.homeip.net>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 16 Sep 2009 11:49:32 +0800
Message-ID: <3c17e3570909152049nd801aeds3915e5889d6181f0@mail.gmail.com>
Subject: Re: [PATCH] input/keyboard: add ADP5588 QWERTY I2C Keyboard Input 
	device driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 12:26 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Sep 15, 2009 at 07:19:14AM -0400, Mike Frysinger wrote:
>> On Tue, Sep 15, 2009 at 02:20, Dmitry Torokhov wrote:
>> > On Mon, Sep 14, 2009 at 06:18:39PM -0400, Mike Frysinger wrote:
>> >> +static int __devexit adp5588_remove(struct i2c_client *client)
>> >> +{
>> >> +     struct adp5588_kpad *kpad = dev_get_drvdata(&client->dev);
>> >> +
>> >> +     adp5588_write(client, CFG, 0);
>> >> +     free_irq(client->irq, kpad);
>> >
>> > cancel_work_sync() is missing. Could you try the updated version below?
>>
>> i dont think i have any adp5588 hardware.  Robin: do we have any in
>> Norwood ?  otherwise, it'll have to wait for Michael to get back to
>> double check.
>>
>> > BTW, maybe you shoudl convert to threaded IRQs here?
>>
>> yes, after your suggestion for the previous driver, we've been looking
>> at all our input drivers to convert to threaded IRQs.  do we need to
>> convert all of them before acceptance, or can we merge now and post an
>> updated patch after ?
>
> It really depends on the driver. If there is a race between IRQ and the
> WQ in the driver I will request you to fix it one way or another before
> accepting the driver (and quite often using threaded IRQ gets rid of the
> race). In the cases like this particular driver though I am not even
> convinced that we need threaded IRQ. The driver is not expected to
> generate lots of events rapidly so using keventd as it does now is
> probably the best solution.
Even though CONFIG_GENERIC_HARDIRQS is almost always "y", in case
CONFIG_GENERIC_HARDIRQS is "n" not "y", threaded_irq will become
original irq, drivers will not work. So is it necessary to check the
dependence of GENERIC_HARDIRQS while using threaded_irq?
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
