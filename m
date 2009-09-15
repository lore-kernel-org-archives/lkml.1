Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZIOLTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZIOLTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZIOLTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:19:32 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:50429 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbZIOLTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VXTAxxI9yxhblebnsN5qTCuvIQpGVH/bES44RYNWCxKUfrhgWr9ya2viUUH4u13A+5
         FonOEW4o0ltP2087nYT0rrWzdlHiG+o9GTRVlPc0rgfVs2R5ckqdZRPzwpZKRx4LtCQL
         PFuVgzBHYJPJPNA9YPihvxJREMA57H+u4rkec=
MIME-Version: 1.0
In-Reply-To: <20090915062050.GB10232@core.coreip.homeip.net>
References: <1252966719-27557-1-git-send-email-vapier@gentoo.org> 
	<20090915062050.GB10232@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 07:19:14 -0400
Message-ID: <8bd0f97a0909150419p1048bfe9j243fa30a0581b198@mail.gmail.com>
Subject: Re: [PATCH] input/keyboard: add ADP5588 QWERTY I2C Keyboard Input 
	device driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 02:20, Dmitry Torokhov wrote:
> On Mon, Sep 14, 2009 at 06:18:39PM -0400, Mike Frysinger wrote:
>> +static int __devexit adp5588_remove(struct i2c_client *client)
>> +{
>> +     struct adp5588_kpad *kpad = dev_get_drvdata(&client->dev);
>> +
>> +     adp5588_write(client, CFG, 0);
>> +     free_irq(client->irq, kpad);
>
> cancel_work_sync() is missing. Could you try the updated version below?

i dont think i have any adp5588 hardware.  Robin: do we have any in
Norwood ?  otherwise, it'll have to wait for Michael to get back to
double check.

> BTW, maybe you shoudl convert to threaded IRQs here?

yes, after your suggestion for the previous driver, we've been looking
at all our input drivers to convert to threaded IRQs.  do we need to
convert all of them before acceptance, or can we merge now and post an
updated patch after ?
-mike
