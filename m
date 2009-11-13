Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbZKMRTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbZKMRTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755972AbZKMRTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:19:00 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60766 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbZKMRS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:18:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=eVHsiSZEpnAOTKdBI6+vHpzP0smei921+6F3omdd6MH6OXUWHhUXBP6NE++pyZIiMb
         Go/vhXTadZO1bOi1NGWDVHuDbUXA7N/tACsmErmQKi1Qk/4/Qc98UD3iZ5XXZinINXlx
         D3/ECOaGrJGDheACR2l/Mza6vfamj95sk7J8c=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0911100412yb51d472r24be8b2068204348@mail.gmail.com>
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> 
	<200911072152.57596.trenn@suse.de> <4AF5F47C.5000402@linux.intel.com> 
	<200911072347.05786.trenn@suse.de> <4AF5FBC7.9000105@linux.intel.com> 
	<43e72e890911090832v1c809482yde7e767502271376@mail.gmail.com> 
	<4e5e476b0911100412yb51d472r24be8b2068204348@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 13 Nov 2009 09:18:43 -0800
Message-ID: <43e72e890911130918v5a4c4fabt2deda5a4ab75ff5@mail.gmail.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Jonathan May <Jonathan.May@atheros.com>,
       Thomas Renninger <trenn@suse.de>, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Garrett <mjg@redhat.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Amod Bodas <Amod.Bodas@atheros.com>,
       David Quan <David.Quan@atheros.com>,
       Kishore Jotwani <Kishore.Jotwani@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 4:12 AM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> Hi,
> On Mon, Nov 9, 2009 at 5:32 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>> And we tested this (reducing the min cpu freq to one less than the
>> highest supported P state to avoid an FSB speed change) and it seems
>> doing the steps described here did not fix the issue. But at least now
>> if anyone else wants to verify this they can with some sort of
>> documentaiton.
>>
>> So to confirm though -- we are seeing a huge performance depredation
>> mainly on RX on an Intel Pine Trail platform with SpeedStep enabled on
>> the BIOS.
>>
>> Let me get into the specifics in case anyone is able to help. The
>> issue is with ath9k on RX and the CPU on C3 state requesting DMA over
>> PCI-E. We typically would get about 110 Mbps with an AR9285 (single
>> stream) but when SpeedStep is enabled it goes down to 25 Mbps. At the
>> PCI-E level we are seeing huge latencies introduced when SpeedStep is
>> used for DMA requests to the Intel root complex on the Intel Pine
>> trail platform. Latencies are about 20-60 us.
>
> You mentioned speedstep and cpufreq, but the problem is with C3 state
> and cpuidle (probably the BIOS mixes the two concepts, but we should
> keep them separated).
> C3 is not related to the core or FSB frequency, it is an idle state.
> When in C3, the CPU is not ready to perform any operation, not just
> slower, and depending on the CPU hw, it may take several us to wake up
> (even 85us, on an Atom).
>
>>
>> Is there a timeout threshold change that will cause the Intel chipset
>> wait for some time after completion before going into a C3 state? Are
>> there any other explanations for seeing such huge latencies on C3
>> state?
> There is a patch from Arjan for the cpuidle menu governor, that may fix it.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-09/msg05276.html
> It is already present in 2.6.32.

Thanks all for your feedback -- this was determined to be a BIOS bug
:) Anyway, hope you do consider the patch for inclusion.

  Luis
