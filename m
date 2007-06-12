Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbXFLSIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbXFLSIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbXFLSIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:08:30 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbXFLSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:08:29 -0400
Message-ID: <466EE115.9030805@zytor.com>
Date: Tue, 12 Jun 2007 11:08:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: allocation failed: out of vmalloc space - use vmalloc=<size>
 to increase size.
References: <6278d2220706121001r38a1752axba90de1b4e315f75@mail.gmail.com>
In-Reply-To: <6278d2220706121001r38a1752axba90de1b4e315f75@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> On 12 Jun, 14:30, Jon Dufresne
> <jon.dufresne@infinitevideocorporation.com> wrote:
>> I am writing a linux kernel driver for a custom pci device. I am
>> developing against the stock fedora 6 kernel on an x86. This device has
>> 512 MB of IO memory reserved by BAR 3. Whenever I try to ioremap this
>> space I get the error:

You don't have a prayer mapping 512 MB at once on an x86-32 machine.
The kernel only has 1 GB of address space *total*.  You either need to
map it in chunks or restrict yourself to 64-bit machines.

>> allocation failed: out of vmalloc space - use vmalloc=<size> to increase
>> size.
>>
>> I think I understand why this is happening. I obviously don't have
>> enough vmalloc space to map such a large chunk of memory. I have been
>> using Corbet's et el's "Linux Device Drivers", Love's "Linux Kernel
>> Development", and many websites as a guide in this development process
>> but have yet to come across information that will help me.
>>
>> I'm curious if there is a way around this issue. Or a better way of
>> handling it so that I can properly map the entire io memory space.

No chance.

> You can boot with kernel parameter vmalloc=384M or so. I have
> experienced problems with booting with other values, but YMMV.

The vmalloc= option conflicts with the booting protocol, so it's
basically a crapshoot if it's going to work or not, at least if you're
using an initrd, which pretty much everyone does hese days.

	-hpa
