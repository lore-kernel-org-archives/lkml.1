Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbXEPWol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbXEPWol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXEPWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:44:34 -0400
Received: from alnrmhc11.comcast.net ([206.18.177.51]:46366 "EHLO
	alnrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbXEPWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:44:33 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 18:44:33 EDT
Message-ID: <464B8819.3050303@comcast.net>
Date: Wed, 16 May 2007 18:39:21 -0400
From: Ed Sweetman <safemode2@comcast.net>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
CC: Daniel Drake <dsd@gentoo.org>, Duane Griffin <duaneg@dghda.com>,
       Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States
 driver
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <464B63D8.2060501@gentoo.org> <20070516212736.GO15763@ifa.hawaii.edu>
In-Reply-To: <20070516212736.GO15763@ifa.hawaii.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua Hoblitt wrote:
> On Wed, May 16, 2007 at 04:04:40PM -0400, Daniel Drake wrote:
>   
>> Duane Griffin wrote:
>>     
>>> On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
>>>       
>>>> Maybe you want to give a hint in the p states driver help text?
>>>>         
>>> I think a hint is the right thing to do, but in the PowerNow! driver
>>> rather than the p states one. How about adding something like this to
>>> the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:
>>>       
>> Please hold off this patch until we've gained a more complete 
>> understanding of the issues and workarounds (which will probably lead to 
>> us writing a better patch anyway)
>>     
>
> I agree - the issue is more complicated that I had thought.  I received
> an off list message saying that this dependency isn't required on a
> single-socket Athlon X2 system.  So it sounds like isn't an SMP setup
> issue as much as it is a multi-socket or perhaps just an issue with my
> vendor (Tyan).
>
> -J
>
> --
>   
Like i mentioned off list, the problem here is that cpu freq modules 
dont depend (Kconfig) on CONFIG_ACPI_PROCESSOR, yet they do.  Even the 
help text of CONFIG_ACPI_PROCESSOR says this.  I'm unsure as to why the 
drivers that do, dont make the dependency known to Kconfig, since 
obviously the writer of acpi_processor knew the dependency existed.

Simple fix would be to just include the depends line for 
CONFIG_ACPI_PROCESSOR for the powernow driver, and any others people 
wonna test.   I suspect most people just compile in the acpi_processor 
driver, never seeing this problem occur.


