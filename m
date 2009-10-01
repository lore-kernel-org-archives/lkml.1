Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZJAQjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZJAQjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZJAQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:39:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:45232 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZJAQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u1LnPJ9udwYZ+OQfRU82IBSKZnxyYpMV2j7BicGWh1E/UfveZp8Q53N9uvLHRTCcVQ
         aOHoOBFQ6HVaEGiWVwlM8bQAQdOe4orLM9IY4EsMFL3FrlKrkM9gPvyXzjnGkLOib0xN
         q64SNB14Sy1TA+/o6ovSFk2xVK5o71bPYvSc8=
Date: Thu, 1 Oct 2009 09:38:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, len.brown@intel.com, don@syst.com.br,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] cmpc_acpi: Added support for Classmate PC ACPI devices.
Message-ID: <20091001163857.GB22320@core.coreip.homeip.net>
References: <1254188280-29155-1-git-send-email-cascardo@holoscopio.com> <9b2b86520909290220g6b5f6beal6337b17f1bdd339@mail.gmail.com> <20090929141618.GD18847@vespa.holoscopio.com> <9b2b86520909290941g6295ba36i907dfda62b968529@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520909290941g6295ba36i907dfda62b968529@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 05:41:42PM +0100, Alan Jenkins wrote:
> On 9/29/09, Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> 
> >> > +static void cmpc_tablet_idev_init(struct input_dev *inputdev)
> >> > +{
> >> > +	set_bit(EV_SW, inputdev->evbit);
> >> > +	set_bit(SW_TABLET_MODE, inputdev->swbit);
> >>
> >> Don't you need to initialize the switch value here?
> >>
> >
> > No, input_allocate_device does kzalloc. Otherwise, this would apply to
> > the other bitmaps as well.
> 
> The other bitmaps aren't for switches though.  Here's what prompted
> this comment - a snippet from the old (2.6.29) version of
> Documentation/rfkill.txt:
> 
> "2. Input device switches (sources of EV_SW events) DO store their current state
> (so you *must* initialize it by issuing a gratuitous input layer event on
> driver start-up and also when resuming from sleep), and that state CAN be
> queried from userspace through IOCTLs."
> 

There is a mixup betweeb capabilieies and state bitmasks. In init you
set up the capabilitis bits and you don't need to clear bitmaps. This is
true for everything - keys/buttons, switches, relatixe/absolute axis,
everything.

Now switches do naturally have a certain state. Unlke keys (which are
assumed to be normally in released state) switch can be on or off. So
the driver has (if it can) query the switch state (hardware state) and
issue appropriate input_event() to bring internal state of the device in
sync with the state of the hardware. The same on resume - the switch may
be altered while the box was asleep to upon resume we need to do the
same.

-- 
Dmitry
