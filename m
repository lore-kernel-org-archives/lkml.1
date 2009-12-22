Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbZLVA67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbZLVA67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZLVA66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:58:58 -0500
Received: from smtp110.rog.mail.re2.yahoo.com ([206.190.37.120]:23647 "HELO
	smtp110.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750970AbZLVA66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:58:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=6I5DKy/Zf2WQU6HI1OXCTfA2IV0JrQfyIGxwxZ91tdD2ySWdpBPVcbDM0c1Rt36ZuOKDeiY9LGhPAIv5eI9w93CK8C4maIk/jUJFBaOsVeUJgbJjqjd8Ecs9yh3fLFy7qWogLTd6eBaB9/cbuD7bT6HucfS5JW/lO2AtxGvw1zI=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: TVNPudoVM1l0vM_j0vO3L6jg5rHMCytu4dKUme_LhGpZktkyW1tQi.clya3eUdUsaA--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [2.6.33-rc1] System timer flooding bus on Lenovo Thinkpad W500 laptop in x86_64
Date: Mon, 21 Dec 2009 19:58:51 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc1-custom-radeon; KDE/4.3.82; x86_64; svn-1062525; 2009-12-14)
Cc: linux-kernel@vger.kernel.org
References: <200912211312.52769.shawn.starr@rogers.com> <4B301744.2010404@gmail.com>
In-Reply-To: <4B301744.2010404@gmail.com>
MIME-Version: 1.0
Message-Id: <200912211958.52120.shawn.starr@rogers.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 21, 2009 07:48:04 pm Robert Hancock wrote:
> On 12/21/2009 12:12 PM, Shawn Starr wrote:
> > Hello kernel devs,
> >
> > I am noticing a serious problem with the system timer flooding the bus
> > with many interrupts for no reason. I have compiled the kernel with
> > tickless enabled.
> >
> > Can someone provide me some debugging to find out why this is happening?
> >
> > As a comparsion my quad core box has no such issue: (Running 2.6.32-rc7)
> > x86_64
> >    0:         42          4          1          1   IO-APIC-edge     
> > timer
> 
> That's not really a fair comparison, that box is likely using the APIC
> timer (which will be on a different line) instead of the PC timer. Those
> 48 interrupts likely all occurred just after boot.
> 
> > my Lenovo ThinkPad W500 (latest BIOS 3.11) laptop shows the system timer
> > flooding the bus (Running 2.6.33-rc1) x86_64
> >   0:      66775      70429   IO-APIC-edge      timer<-- keeps rising,
> > rapidly
> >
> > and  afew minutes ...
> >
> >   0:     119849     124505   IO-APIC-edge      timer
> >
> > Same for Rescheduling interrupts rising just as fast with the timer.
> >
> > This does not look right, powertop shows:
> >
> > 40.0% ( 62.1)<kernel IPI>  : Rescheduling interrupts
> > 22.9% ( 35.6)<interrupt>  : extra timer interrupt
> > 17.0% ( 26.4)<interrupt>  : iwlagn
> >
> > and another sample...
> >
> >    54.6% (144.8)<kernel IPI>  : Rescheduling interrupts
> >    14.6% ( 38.8)<interrupt>  : extra timer interrupt
> >     8.5% ( 22.6)<interrupt>  : iwlagn
> >     6.5% ( 17.2)<interrupt>  : uhci_hcd:usb6, radeon@pci:0000:01:00.0
> >     6.5% ( 17.2)   USB device  6-1 : Microsoft Basic Optical Mouse v2.0
> > (Microsoft )
> >
> > There is no cause for the rescheduling interrupts and extra timer
> > interrupt to wakeup the CPUs so much? Are there any timer issues?
> 
> Can you post full dmesg and /proc/interrupts output?
> 

This is found in http://bugzilla.kernel.org/show_bug.cgi?id=14354. 

Turning off dynticks has stopped the system timer from firing so much. But 
there still is an underlying irq problem because especially trying the radeon 
KMS IRQ support, typing or moving the mouse causes stalls. 

Thanks, 
Shawn.
