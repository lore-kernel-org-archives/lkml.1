Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXBJCFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXBJCFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 21:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXBJCFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 21:05:54 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:49991 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbXBJCFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 21:05:53 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <45CD24F6.8090107@shaw.ca>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
	 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no>  <45CD24F6.8090107@shaw.ca>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 13:05:49 +1100
Message-Id: <1171073149.3863.4.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 2007-02-09 at 19:50 -0600, Robert Hancock wrote:
> Jeff Garzik wrote:
> > Nigel Cunningham wrote:
> >> Hi.
> >>
> >> On Fri, 2007-02-09 at 23:17 +0100, Arjan van de Ven wrote:
> >>> On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
> >>>> Hi.
> >>>>
> >>>> I don't think this is already done (feel free to correct me if I'm
> >>>> wrong)..
> >>>>
> >>>> Can we start to NAK new drivers that don't have proper power management
> >>>> implemented? There really is no excuse for writing a new driver and not
> >>>> putting .suspend and .resume methods in anymore, is there?
> >>>
> >>> to a large degree, a device driver that doesn't suspend is better than
> >>> no device driver at all, right?
> >>
> >> I'm not sure it is. It only makes more work for everyone else: We have
> >> to help people figure out what causes their computer to fail to resume
> >> (which can take quite a while), then get them them complain to driver
> >> author, and the driver author has to submit patches to fix it.
> >>
> >> All of this is avoided if they'll just do it right in the first place.
> > 
> > A lot of a lot of things could have been avoided, if they just did it 
> > right the first time.
> > 
> > I think it's more valuable to users to get a basic network driver that 
> > pings or a basic ATA driver that reads/writes, than peripheral issues 
> > like suspend/resume.
> > 
> > Certainly we should ask for it, but it shouldn't be a merge-stopper.
> > 
> >     Jeff
> 
> I would disagree that it's a peripheral issue, it's pretty core these 
> days, at least for any hardware that you can stuff in a laptop (though a 
> fair number of desktops get suspended and resumed these days too). One 
> driver on a system which doesn't suspend or resume properly can ruin the 
> entire process, causing a ton of user frustration. Certainly I would 
> consider a driver without suspend/resume support to be incomplete.
> 
> The trouble with deferring adding this support is that it's a lot harder 
> to add this support in after the fact than if it was considered during 
> the original driver development.
> 
> I would be in favor of not merging drivers lacking suspend unless 
> there's a very good reason they're lacking it.
> 
> It also kind of bothers me that if a driver has no suspend/resume 
> functions, and you suspend and resume the system, we don't complain 
> about it even though there's a very good chance that device is not going 
> to function properly. How about something in dmesg like:
> 
> Warning: driver for device XXXX has no suspend or resume support.
> Device may not function properly after resume.
> 
> so that users know who to complain to. Maybe there are some devices that 
> truly don't need any handling for suspend, but if so I suspect the 
> number of those is small enough that adding empty functions would be a 
> good-enough solution.

I've already made a start on doing just that. Rafael was clearly right
in asserting that some drivers would need to have warnings suppressed,
but that can be dealt with (see below).

Even if no-one wants it for vanilla, I think I'll put this in Suspend2.
It will at least help my users with debugging issues.

Regards,

Nigel

[   14.936667] Device driver platform lacks bus and class support for being suspended or resumed.
[   14.937612] Device driver vtcon0 lacks bus and class support for being suspended or resumed.
[   14.955258] Device driver pci0000:00 lacks bus and class support for being suspended or resumed.
[   15.004268] Device driver pnp0 lacks bus and class support for being suspended or resumed.
[   15.010618] Device driver mem lacks bus and class support for being suspended or resumed.
[   15.010779] Device driver kmem lacks bus and class support for being suspended or resumed.
[   15.010932] Device driver null lacks bus and class support for being suspended or resumed.
[   15.011090] Device driver port lacks bus and class support for being suspended or resumed.
[   15.011248] Device driver zero lacks bus and class support for being suspended or resumed.
[   15.011414] Device driver full lacks bus and class support for being suspended or resumed.
[   15.011566] Device driver random lacks bus and class support for being suspended or resumed.
[   15.011723] Device driver urandom lacks bus and class support for being suspended or resumed.
[   15.011875] Device driver kmsg lacks bus and class support for being suspended or resumed.
[   15.305495] Device driver mcelog lacks bus and class support for being suspended or resumed.
[   15.305688] Device driver msr0 lacks bus and class support for being suspended or resumed.
[   15.306571] Device driver snapshot lacks bus and class support for being suspended or resumed.
[   15.359006] Device driver fb0 lacks bus and class support for being suspended or resumed.
[   15.359471] Device driver vtcon1 lacks bus and class support for being suspended or resumed.
[   15.455642] Device driver tty lacks bus and class support for being suspended or resumed.
[   15.455815] Device driver console lacks bus and class support for being suspended or resumed.
[   15.455991] Device driver ptmx lacks bus and class support for being suspended or resumed.
[   15.456157] Device driver tty0 lacks bus and class support for being suspended or resumed.
[   15.456336] Device driver vcs lacks bus and class support for being suspended or resumed.
[   15.456495] Device driver vcsa lacks bus and class support for being suspended or resumed.
[   15.456668] Device driver tty1 lacks bus and class support for being suspended or resumed.
[   15.456860] Device driver tty2 lacks bus and class support for being suspended or resumed.
[   15.457057] Device driver tty3 lacks bus and class support for being suspended or resumed.
[   15.457256] Device driver tty4 lacks bus and class support for being suspended or resumed.
[   15.457447] Device driver tty5 lacks bus and class support for being suspended or resumed.
[   15.457642] Device driver tty6 lacks bus and class support for being suspended or resumed.
[   15.457833] Device driver tty7 lacks bus and class support for being suspended or resumed.
[   15.458024] Device driver tty8 lacks bus and class support for being suspended or resumed.
[   15.458219] Device driver tty9 lacks bus and class support for being suspended or resumed.
[   15.458419] Device driver tty10 lacks bus and class support for being suspended or resumed.
[   15.458615] Device driver tty11 lacks bus and class support for being suspended or resumed.
[   15.458808] Device driver tty12 lacks bus and class support for being suspended or resumed.
...
[   15.469106] Device driver rtc lacks bus and class support for being suspended or resumed.
[   15.469283] Device driver hpet lacks bus and class support for being suspended or resumed.
[   15.469585] Device driver ttyS0 lacks bus and class support for being suspended or resumed.
[   15.469777] Device driver ttyS1 lacks bus and class support for being suspended or resumed.
[   15.469972] Device driver ttyS2 lacks bus and class support for being suspended or resumed.
[   15.470173] Device driver ttyS3 lacks bus and class support for being suspended or resumed.
[   15.470808] Device driver ttyS0 lacks bus and class support for being suspended or resumed.
[   15.471159] Device driver ttyS0 lacks bus and class support for being suspended or resumed.
[   15.471501] Device driver ttyS0 lacks bus and class support for being suspended or resumed.
[   15.471844] Device driver ttyS0 lacks bus and class support for being suspended or resumed.
[   15.472213] Device driver ttyS0 lacks bus and class support for being suspended or resumed.
[   15.472583] Device driver ttyS1 lacks bus and class support for being suspended or resumed.
[   15.472916] Device driver ttyS2 lacks bus and class support for being suspended or resumed.
[   15.473271] Device driver ttyS2 lacks bus and class support for being suspended or resumed.
[   15.473641] Device driver ttyS2 lacks bus and class support for being suspended or resumed.
[   15.474009] Device driver ttyS3 lacks bus and class support for being suspended or resumed.
[   15.775682] Device driver ide0 lacks bus and class support for being suspended or resumed.
[   17.632766] Device driver ide1 lacks bus and class support for being suspended or resumed.
[   17.633462] PCI driver ALI15x3_IDE lacks driver specific suspend and resume support.
[   17.633465] PCI driver ALI15x3_IDE lacks a driver specific resume method.
[   17.633547] PCI driver PIIX_IDE lacks driver specific suspend and resume support.
[   17.633549] PCI driver PIIX_IDE lacks a driver specific resume method.
[   17.684475] Device driver serio0 lacks bus and class support for being resumed.
[   17.684724] Device driver serio1 lacks bus and class support for being resumed.
[   17.684874] Device driver psaux lacks bus and class support for being suspended or resumed.
[   17.685015] Device driver serio2 lacks bus and class support for being resumed.
[   18.373576] Device driver serio3 lacks bus and class support for being resumed.
[   18.375666] Device driver serio4 lacks bus and class support for being resumed.
...
[   22.656888] Device driver timer lacks bus and class support for being suspended or resumed.
[   23.314970] Device driver pcmC0D2p lacks bus and class support for being suspended or resumed.
[   23.315327] Device driver pcmC0D1c lacks bus and class support for being suspended or resumed.
[   23.315648] Device driver adsp lacks bus and class support for being suspended or resumed.
[   23.316036] Device driver pcmC0D0p lacks bus and class support for being suspended or resumed.
[   23.316352] Device driver pcmC0D0c lacks bus and class support for being suspended or resumed.
[   23.316672] Device driver dsp lacks bus and class support for being suspended or resumed.
[   23.317053] Device driver audio lacks bus and class support for being suspended or resumed.
[   23.317530] Device driver controlC0 lacks bus and class support for being suspended or resumed.
[   23.317875] Device driver mixer lacks bus and class support for being suspended or resumed.
[   28.806277] Device driver vcs1 lacks bus and class support for being suspended or resumed.
[   28.806479] Device driver vcsa1 lacks bus and class support for being suspended or resumed.
[   71.656860] Device driver vcs1 lacks bus and class support for being suspended or resumed.
[   71.657062] Device driver vcsa1 lacks bus and class support for being suspended or resumed.
[   71.657563] Device driver vcs1 lacks bus and class support for being suspended or resumed.
[   71.657758] Device driver vcsa1 lacks bus and class support for being suspended or resumed.
[   71.658342] Device driver vcs1 lacks bus and class support for being suspended or resumed.
[   71.658530] Device driver vcsa1 lacks bus and class support for being suspended or resumed.
[   71.674825] Device driver vcs1 lacks bus and class support for being suspended or resumed.
[   71.675010] Device driver vcsa1 lacks bus and class support for being suspended or resumed.
[   75.573394] PCI driver ali15x3_smbus lacks driver specific suspend and resume support.
[   75.573396] PCI driver ali15x3_smbus lacks a driver specific resume method.
[   75.844125] Device driver usbdev1.1_ep00 lacks bus and class support for being suspended or resumed.
[   75.951810] Device driver usbdev1.1_ep81 lacks bus and class support for being suspended or resumed.
[   76.013809] Device driver usbdev2.1_ep00 lacks bus and class support for being suspended or resumed.
[   76.121522] Device driver usbdev2.1_ep81 lacks bus and class support for being suspended or resumed.
[   76.122026] PCI driver ali1535_smbus lacks driver specific suspend and resume support.
[   76.122028] PCI driver ali1535_smbus lacks a driver specific resume method.
[   76.151696] Device driver usbdev3.1_ep00 lacks bus and class support for being suspended or resumed.
[   76.301270] Device driver usbdev3.1_ep81 lacks bus and class support for being suspended or resumed.
[   86.348191] Device driver vcs7 lacks bus and class support for being suspended or resumed.
[   86.348373] Device driver vcsa7 lacks bus and class support for being suspended or resumed.
[  113.547039] Device driver vmmon lacks bus and class support for being suspended or resumed.


