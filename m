Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZLVAsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZLVAsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZLVAsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:48:09 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:60899 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZLVAsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=GLRJzL9vyC0qd1+VjahPLfvoHyzD0HbaCmYbwaTwNxkTXjLl0+UH/fU09YUT5P2/3Q
         I7RMe44eGDFb8FqV7BXO8TyTmP29M1Ds0HDuJGUDix16J80zBeWjVX66Q0d9UeBdErcZ
         vceszTQPWlnQljGmRoqt0VXdfgDB81zhT4w9s=
Message-ID: <4B301744.2010404@gmail.com>
Date: Mon, 21 Dec 2009 18:48:04 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Shawn Starr <shawn.starr@rogers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc1] System timer flooding bus on Lenovo Thinkpad W500
 laptop in x86_64
References: <200912211312.52769.shawn.starr@rogers.com>
In-Reply-To: <200912211312.52769.shawn.starr@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 12:12 PM, Shawn Starr wrote:
> Hello kernel devs,
>
> I am noticing a serious problem with the system timer flooding the bus with
> many interrupts for no reason. I have compiled the kernel with tickless
> enabled.
>
> Can someone provide me some debugging to find out why this is happening?
>
> As a comparsion my quad core box has no such issue: (Running 2.6.32-rc7)
> x86_64
>    0:         42          4          1          1   IO-APIC-edge      timer

That's not really a fair comparison, that box is likely using the APIC 
timer (which will be on a different line) instead of the PC timer. Those 
48 interrupts likely all occurred just after boot.

>
> my Lenovo ThinkPad W500 (latest BIOS 3.11) laptop shows the system timer
> flooding the bus (Running 2.6.33-rc1) x86_64
>   0:      66775      70429   IO-APIC-edge      timer<-- keeps rising, rapidly
>
> and  afew minutes ...
>
>   0:     119849     124505   IO-APIC-edge      timer
>
> Same for Rescheduling interrupts rising just as fast with the timer.
>
> This does not look right, powertop shows:
>
> 40.0% ( 62.1)<kernel IPI>  : Rescheduling interrupts
> 22.9% ( 35.6)<interrupt>  : extra timer interrupt
> 17.0% ( 26.4)<interrupt>  : iwlagn
>
> and another sample...
>
>    54.6% (144.8)<kernel IPI>  : Rescheduling interrupts
>    14.6% ( 38.8)<interrupt>  : extra timer interrupt
>     8.5% ( 22.6)<interrupt>  : iwlagn
>     6.5% ( 17.2)<interrupt>  : uhci_hcd:usb6, radeon@pci:0000:01:00.0
>     6.5% ( 17.2)   USB device  6-1 : Microsoft Basic Optical Mouse v2.0
> (Microsoft )
>
> There is no cause for the rescheduling interrupts and extra timer interrupt to
> wakeup the CPUs so much? Are there any timer issues?

Can you post full dmesg and /proc/interrupts output?
