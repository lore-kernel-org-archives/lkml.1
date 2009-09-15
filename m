Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZIORR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZIORR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 13:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZIORR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 13:17:56 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45319 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZIORRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 13:17:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=BXrEkNtgVeZV7toERESI50A9UZWiHVdfRzQUMPjuDLtP58Pxn6Nxb5x6oC+il7Rzy6
         bToMytoTk+nkuuP3/+hjd4JExhwrbChd3Wqilx9skL2XBY0qtbsFsVWmzXLFFlo/vA9g
         K1sqpAtfxA8afzZAmbBQIErnOTfnCNmu9Vbgk=
Date: Tue, 15 Sep 2009 10:17:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] input/keyboard: add ADP5588 QWERTY I2C Keyboard Input
	device driver
Message-ID: <20090915171747.GC29241@core.coreip.homeip.net>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> <20090915062050.GB10232@core.coreip.homeip.net> <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com> <20090915162655.GB29241@core.coreip.homeip.net> <8bd0f97a0909150946t65c445ddo6741c2a472c1738c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0909150946t65c445ddo6741c2a472c1738c@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 12:46:14PM -0400, Mike Frysinger wrote:
> On Tue, Sep 15, 2009 at 12:26, Dmitry Torokhov wrote:
> > On Tue, Sep 15, 2009 at 07:19:14AM -0400, Mike Frysinger wrote:
> >> On Tue, Sep 15, 2009 at 02:20, Dmitry Torokhov wrote:
> >> > On Mon, Sep 14, 2009 at 06:18:39PM -0400, Mike Frysinger wrote:
> >> >> +static int __devexit adp5588_remove(struct i2c_client *client)
> >> >> +{
> >> >> +     struct adp5588_kpad *kpad = dev_get_drvdata(&client->dev);
> >> >> +
> >> >> +     adp5588_write(client, CFG, 0);
> >> >> +     free_irq(client->irq, kpad);
> >> >
> >> > cancel_work_sync() is missing. Could you try the updated version below?
> >>
> >> i dont think i have any adp5588 hardware.  Robin: do we have any in
> >> Norwood ?  otherwise, it'll have to wait for Michael to get back to
> >> double check.
> >>
> >> > BTW, maybe you shoudl convert to threaded IRQs here?
> >>
> >> yes, after your suggestion for the previous driver, we've been looking
> >> at all our input drivers to convert to threaded IRQs.  do we need to
> >> convert all of them before acceptance, or can we merge now and post an
> >> updated patch after ?
> >
> > It really depends on the driver. If there is a race between IRQ and the
> > WQ in the driver I will request you to fix it one way or another before
> > accepting the driver (and quite often using threaded IRQ gets rid of the
> > race). In the cases like this particular driver though I am not even
> > convinced that we need threaded IRQ. The driver is not expected to
> > generate lots of events rapidly so using keventd as it does now is
> > probably the best solution.
> 
> i dont think there is a race here as we only use the IRQ to schedule
> the WQ; we dont read/pass info between the two.
> 

Right, that's what I was trying to say - there is no race in
thisparticular driver.

> at any rate, i noticed that this driver isnt the final one.  i spent
> some time cleaning it up a bit more (style, messages, dev_pm_ops), so
> i'll merge your changes and mine and post another one.

OK, great.

-- 
Dmitry
