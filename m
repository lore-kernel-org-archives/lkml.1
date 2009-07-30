Return-Path: <linux-kernel-owner+w=401wt.eu-S1751097AbZG3Mw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbZG3Mw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZG3Mw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:52:56 -0400
Received: from mail-px0-f203.google.com ([209.85.216.203]:50134 "EHLO
	mail-px0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZG3Mwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Kq8hd1jkANnckax6QBsigFIOWSzZ40dLKjXwhsi5Cfnu5u+U/A4wZymeGyM2RQuG2v
         yxeWr5x3dNkokb7u/WwWM/YBCFM4qp5s+2AM90cqebxj13OisCGkWhBdRgPwQSYgiIgA
         WC406BOffFzm6X7MOO7nRVD9iyxmG0yX8nmo8=
MIME-Version: 1.0
In-Reply-To: <20090730123633.GA2739@rakim.wolfsonmicro.main>
References: <b90c0690907300520t1dfbd722j73417b1beb6992bc@mail.gmail.com>
	 <20090730123633.GA2739@rakim.wolfsonmicro.main>
Date: Thu, 30 Jul 2009 15:52:55 +0300
Message-ID: <b90c0690907300552h21157341v5820cf51261ddf42@mail.gmail.com>
Subject: Re: regulator: adding enable control to fixed regulator interface
From: Roger Quadros <quadros.roger@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 3:36 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 30, 2009 at 03:20:24PM +0300, Roger Quadros wrote:
>
> [Cut description of GPIO-switched regulator.]
>
>> What is the best way to implement this within the regulator framework?
>> Writing a regulator driver is one solution but I'm sure there must be
>> many instances like this and writing a driver for each case is not
>> that nice.
>
> Only one driver should be needed even if a new driver is implemented for
> this - we already have an abstracted API for GPIOs in the form of
> gpiolib (see drivers/gpio) so the driver can just take in platform data
> with the gpio number and a voltage as platform data.
>

Yes using gpiolib makes sense. In this case we need to obtain GPIO number
and enabling polarity (active high/low) through platform data.

>> I want to use the fixed regulator driver but this does not have
>> regulator enable/disable control.
>
>> Isn't it a good idea to have enable/disable control for the current
>> implementation of the fixed voltage regulator i.e. drivers/regulator/fixed.c ?
>
> It should be possible to do it with platform data for the fixed voltage
> regulator, though without looking at the code I can't say for certain if
> it'd be easier to just add a separate driver rather than have the
> conditional code to handle cases both with and without GPIO.  I'd expect
> it'll be fine to combine, though.
>
>> The regulator enabling/disabling functionality can be implemented by
>> platform code and the required function pointers could be passed through
>> fixed_voltage_config structure.
>
> I don't see any need for platform code to provide callbacks here given
> the existing gpiolib abstraction.
>
