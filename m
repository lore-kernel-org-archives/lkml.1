Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZLIGx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZLIGx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbZLIGxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:53:25 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43913 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbZLIGxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:53:24 -0500
Message-ID: <4B1F4963.3070405@canonical.com>
Date: Wed, 09 Dec 2009 14:53:23 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Corentin Chary <corentin.chary@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Alexandre Rostovtsev <tetromino@gmail.com>
Subject: Re: [Resend] [PATCH] asus-laptop: add Lenovo SL LenovoCare LED 	support
References: <1260257829-7343-1-git-send-email-ike.pan@canonical.com>	 <20091208154154.GA26435@srcf.ucam.org> <71cd59b00912080932nf334ba7uf65c70178fec41a5@mail.gmail.com>
In-Reply-To: <71cd59b00912080932nf334ba7uf65c70178fec41a5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corentin Chary wrote:
> On Tue, Dec 8, 2009 at 4:41 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>> On Tue, Dec 08, 2009 at 03:37:09PM +0800, Ike Panhc wrote:
>>
>>>  ASUS_HANDLE(rled_set, ASUS_HOTK_PREFIX "RLED");      /* W1JC */
>>>  ASUS_HANDLE(pled_set, ASUS_HOTK_PREFIX "PLED");      /* A7J */
>>>  ASUS_HANDLE(gled_set, ASUS_HOTK_PREFIX "GLED");      /* G1, G2 (probably) */
>> The driver is controlling the ATKD device, which has a HID of ATK0101.
>> These devices are all underneath it...
>>
>>> +ASUS_HANDLE(lled_set, "\\_SB_.PCI0.SBRG.EC0_.HKEY.TVLS"); /* LenovoCare */
>> And this one isn't, which is a bit jarring. Looking closer, it's under
>> the LEN0014 device, which means that you're trying to touch a method
>> that belongs to a device other than the one this driver is bound to.
>> That's wrong. You want a separate ACPI driver for the LEN0014 device,
>> and this should be called for there. Looking at it, you seem to get
>> rfkill as well (the GWAN/SWAN, GBDC/SBDF and GUWB/SUWB methods) and
>> maybe some other stuff.
>>
>> So this shouldn't go in asus-laptop. You'll need to add another separate
>> driver for the SL-specific functionality.
> 
> That means asus-laptop and sl-laptop will be both needed for a SL
> laptop, but I don't think this is a problem.
> 
I think your suggestion is that one acpi driver for one acpi device.
It makes sense to me. I will build a new driver.

