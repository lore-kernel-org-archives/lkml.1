Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417Ab0AST6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0AST6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 14:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075Ab0AST6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 14:58:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:54091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074Ab0AST6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 14:58:18 -0500
Message-ID: <4B560EB3.4090604@kernel.org>
Date: Tue, 19 Jan 2010 11:57:39 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Garrett <jeff@jgarrett.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-pci@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] x86/pci: intel ioh need to subtract mmconf range
References: <20100113053736.GA6720@jgarrett.org> <201001141609.19290.bjorn.helgaas@hp.com> <4B4FAAE0.7080608@kernel.org> <201001141649.08554.bjorn.helgaas@hp.com> <4B4FB931.7020301@kernel.org> <20100115101417.2dd32462@jbarnes-piketon> <20100119194228.GA13570@jgarrett.org>
In-Reply-To: <20100119194228.GA13570@jgarrett.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 11:42 AM, Jeff Garrett wrote:
> On Fri, Jan 15, 2010 at 10:14:17AM -0800, Jesse Barnes wrote:
>> On Thu, 14 Jan 2010 16:39:13 -0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> On 01/14/2010 03:49 PM, Bjorn Helgaas wrote:
>>>> On Thursday 14 January 2010 04:38:08 pm Yinghai Lu wrote:
>>>>> On 01/14/2010 03:09 PM, Bjorn Helgaas wrote:
>>>>>> On Thursday 14 January 2010 03:46:35 pm Yinghai Lu wrote:
>>>>>>>
>>>>>>> Bjorn pointed out we need to remove mmconf range
>>>>>>>
>>>>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>>>>
>>>>>>> ---
> ...
>>>>>>
>>>>>> This can't be right, can it?  Let's say the kernel was built with
>>>>>> CONFIG_PCI_MMCONFIG turned off, or the user used "pci=nommconf",
>>>>>> or the kernel decides not to use MMCONFIG for some other reason.
>>>>>>
>>>>>> In that case, the hardware may still be configured to support
>>>>>> MMCONFIG, but the pci_mmcfg_list will be empty, so your code will
>>>>>> leave the window alone.  We might assign some of that MMCONFIG
>>>>>> space to a device, but the hardware will route it to MMCONFIG,
>>>>>> not to the device.
>>>>>
>>>>> so if there is mmconf specified, we just skip the whole function?
>>>>
>>>> No, I'm saying that intel-bus.c must ALWAYS remove the MMCONFIG
>>>> region from the host bridge apertures, even if Linux isn't using
>>>> MMCONFIG.
>>>>
>>>> That means intel-bus.c has to be smart enough to figure out on its
>>>> own what the MMCONFIG area is.  It can't depend on mmconfig-shared.c
>>>> to do it, because mmconfig-shared.c might not be there.
>>>
>>> that seems go too far away...
>>>
>>> Subject: [PATCH -v2] x86/pci: intel ioh need to subtrac mmconf range
>>>
>>> Bjorn pointed out we need to remove mmconf range
>>>
>>> -v2: if mmconf is not there, get out early.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>> ---
> ...
>>
>> This goes against the real intent of intel_bus.c doesn't it?  When we
>> first added it, the thought was that it would be a purely native way of
>> getting at bridge window information and not rely on firmware.  If
>> you're going to make it dependent on MMCONFIG now, why not trust other
>> firmware tables as well, like _CRS?
>>
>> The MMCONFIG ranges are pretty easy to get at, the public docs have
>> info about the registers that control the MMCONFIG decode ranges, so
>> you should be able to read them out and add them to this file,
>> preserving the original intent.
> 
> I did attempt a bisection last week, but my pared down config kept
> hitting a sysfs_create_file panic.  I didn't succeed.
> 
> Should I try the v2 patch above?  What tree is it against?

maybe later with -tip tree + pci/linux-next.

YH
