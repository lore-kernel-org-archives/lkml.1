Return-Path: <linux-kernel-owner+w=401wt.eu-S1756413AbZKIQdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbZKIQdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:33:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZKIQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:33:00 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:61033 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZKIQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=QlBDRIt5Vekg1p4RaYfIV2H1y6ppioa3+JpPwymiuXLAJ59izN5fu7FAq0325fyLle
         jV+HAeVrXSVy3EW3hD3vjlHZMWMvBCk+hBX+K+cpfEv9D3p7Ay9cA2D0gzvnZg3IVXND
         ULTRqrt/J55Oq+jf5En+oanLFe/CBHhVkiLCE=
MIME-Version: 1.0
In-Reply-To: <4AF5FBC7.9000105@linux.intel.com>
References: <1257537660-5301-1-git-send-email-lrodriguez@atheros.com> 
	<200911072152.57596.trenn@suse.de> <4AF5F47C.5000402@linux.intel.com> 
	<200911072347.05786.trenn@suse.de> <4AF5FBC7.9000105@linux.intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 9 Nov 2009 08:32:43 -0800
Message-ID: <43e72e890911090832v1c809482yde7e767502271376@mail.gmail.com>
Subject: Re: [PATCH] cpu-freq: add troubleshooting section for FSB changes
To: Arjan van de Ven <arjan@linux.intel.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       Aeolus Yang <Aeolus.Yang@atheros.com>,
       Jonathan May <Jonathan.May@atheros.com>
Cc: Thomas Renninger <trenn@suse.de>, davej@redhat.com,
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

On Sat, Nov 7, 2009 at 2:59 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>> in addition, most FSB systems have the memory controller in the chipset,
>>> next to the PCI logic... so that the FSB bus for DMA transactions only
>>> carries the snoop traffic, not the whole data.
>>
>> So when should people look at this?
>
> at this point the atheros folks haven't even confirmed that this is the
> cause...

And we tested this (reducing the min cpu freq to one less than the
highest supported P state to avoid an FSB speed change) and it seems
doing the steps described here did not fix the issue. But at least now
if anyone else wants to verify this they can with some sort of
documentaiton.

So to confirm though -- we are seeing a huge performance depredation
mainly on RX on an Intel Pine Trail platform with SpeedStep enabled on
the BIOS.

Let me get into the specifics in case anyone is able to help. The
issue is with ath9k on RX and the CPU on C3 state requesting DMA over
PCI-E. We typically would get about 110 Mbps with an AR9285 (single
stream) but when SpeedStep is enabled it goes down to 25 Mbps. At the
PCI-E level we are seeing huge latencies introduced when SpeedStep is
used for DMA requests to the Intel root complex on the Intel Pine
trail platform. Latencies are about 20-60 us.

Is there a timeout threshold change that will cause the Intel chipset
wait for some time after completion before going into a C3 state? Are
there any other explanations for seeing such huge latencies on C3
state?

Thanks for your review and help with this. Any suggestions are greatly
appreciated.

  Luis
