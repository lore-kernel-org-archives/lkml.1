Return-Path: <linux-kernel-owner+w=401wt.eu-S932254Ab0A0XgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab0A0XgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245Ab0A0XgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:36:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:48265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243Ab0A0XgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:36:15 -0500
Message-ID: <4B60CD99.7020305@kernel.org>
Date: Wed, 27 Jan 2010 15:34:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001271345.54454.bjorn.helgaas@hp.com> <alpine.LFD.2.00.1001271247450.3570@localhost.localdomain> <201001271403.41955.bjorn.helgaas@hp.com>
In-Reply-To: <201001271403.41955.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 01:03 PM, Bjorn Helgaas wrote:
> On Wednesday 27 January 2010 01:50:12 pm Linus Torvalds wrote:
>>
>> On Wed, 27 Jan 2010, Bjorn Helgaas wrote:
>>>
>>> Without intel_bus.c, we essentially assume config 1 all the time.
>>> If we keep intel_bus.c and this patch for .33, things should work
>>> for configs 1 and 4.  Adding support for config 4 is good.
>>
>> Quite frankly, is there any major downside to just disabling/removing 
>> intel_bus.c for 2.6.33? If we're not planning on having it in the long run 
>> anyway - or even if we are, but we can't be really happy about the state 
>> of it as it would be in 2.6.33, not using it at all seems to be the 
>> smaller headache.
>>
>> The machines that it helps are also the machines where you can fix things 
>> up with 'use_csr', no? And they are pretty rare, and they didn't use to 
>> work without that use_csr in 2.6.32 either, so it's not even a regression.
>>
>> Am I missing something?
> 
> Only that when we added intel_bus.c, Yinghai reported that the reason
> was because a machine had a broken _CRS, so "pci=use_crs" wouldn't help.
> 
> At the time, Windows hadn't been brought up on that box.  My
> speculation is that by now, they've done that bringup and probably
> fixed the _CRS issue, so it might work now.
> 
> If that's the case, we could drop intel_bus.c from .33 and just use
> "pci=use_crs" on those boxes until we can figure out how to turn it
> on automatically.

BIOS fixed that problem already. but
1. how to turn that pci=use_crs for that box automatically ?
how about our other kind of boxes?
2. how about when apci is disabled?

let's apply that patch at first, and wait for intel give us info about which bit is used to enable routing set up.

YH

