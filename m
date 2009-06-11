Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbZFKF1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbZFKF1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 01:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZFKF10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 01:27:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:8885 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZFKF1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 01:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m4vauLUtNIN6BNDhJTnK7e4DpZ8t5dpHLV7z/fakR+jHzHJH5wlHJKpPgnz1mnCaOk
         VjphvceArJOEokXo1vI7bIhdWamofcoAFhfJ/XJHOvRFP6Io8VfB3ZS/nGaKDcCJ3LA6
         F/TuuIFiT7cuba2j7RM+4Nu1TaRZpc94S/Mc8=
MIME-Version: 1.0
In-Reply-To: <200906110115.30729.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0906101656100.2589-100000@iolanthe.rowland.org>
	 <200906102331.14267.rjw@sisk.pl>
	 <200906110115.30729.oliver@neukum.org>
Date: Thu, 11 Jun 2009 14:27:26 +0900
Message-ID: <aec7e5c30906102227o18ca40b9w90e889dbdb43464f@mail.gmail.com>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: 
	[RFC][PATCH 0/2] PM: Rearrange core suspend code)
From: Magnus Damm <magnus.damm@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 8:15 AM, Oliver Neukum<oliver@neukum.org> wrote:
> Am Mittwoch, 10. Juni 2009 23:31:13 schrieb Rafael J. Wysocki:
>> > > +/**
>> > > + * pm_check_children - Check if all children of a device have been
>> > > suspended. + * @dev: Device to check.
>> > > + *
>> > > + * Returns 0 if all children of the device have been suspended or
>> > > -EBUSY + * otherwise.
>> > > + */
>> >
>> > We might want to do a runtime suspend even if the device's children
>> > aren't already suspended.  For example, you could suspend a link while
>> > leaving the device on the other end of the link at full power --
>> > especially if powering down the device is slow but changing the link's
>> > power level is fast.
>>
>> Well, this means that the dependencies between devices in the device tree
>> are pretty much useless for the run-time PM as far as the core is
>> concerned.  In which case, why did you mention them at all?
>
> Some bussystems need this constraint others don't or only for some nodes.
> We need a way to communicate this to the core.

I agree that this depends on the bus.

Our SuperH on-chip SoC platform devices are arranged in a flat fashion
so no real problem there, but if there whould be dependencies then I
think we need to manage it recursively somehow.

Compare that to PM of our I2C driver and the I2C bus hanging off from
that. In that case I'd like to be able to autosuspend the I2C master
driver regardless of the I2C slave devices and their PM state.

/ magnus
