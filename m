Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZDMPul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZDMPul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZDMPua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:50:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:6367 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZDMPu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dg0NOQnixCrZdLcch8q5n4Qc9OMYdtWSedIonBAuACvTQvrVoX+YPwQsuBiZHM9nin
         GZjaHWFix5k3Xnqqbje3nhMcucb6O5PE0bg743UBVuTcxet5f7xQ6tKgdPKgiEvM/nu1
         Wm0P0s27PWu1N/H48fwQ2vmuehkX1akpq4edE=
MIME-Version: 1.0
In-Reply-To: <49E2F55F.5060108@garzik.org>
References: <20061031104055.GA8898@infradead.org>
	 <15F501D1A78BD343BE8F4D8DB854566B0C8DDCF5@hkemmail01.nvidia.com>
	 <86802c440711062009t7e98d27fqdfb466b9843da060@mail.gmail.com>
	 <86802c440901180120u3e60e73dm53a37b7cd9034915@mail.gmail.com>
	 <4972F4E5.3030203@kernel.org> <49768355.4040301@kernel.org>
	 <4977DAAF.5060006@kernel.org> <49E2F55F.5060108@garzik.org>
Date: Mon, 13 Apr 2009 08:50:28 -0700
Message-ID: <86802c440904130850r38a1671es68cd2b4cf436c61f@mail.gmail.com>
Subject: Re: [PATCH] sata_nv: sgpio for nvidia mcp55 -v3
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Peer Chen <pchen@nvidia.com>, Kuan Luo <kluo@nvidia.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 1:18 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Yinghai Lu wrote:
>>
>> Impact: new features
>>
>> based on patch on
>>    http://marc.info/?l=linux-ide&m=116289338705418&w=2
>>
>> 1. update the patch for 2.6.19 to latest upstream ( 2.6.28?)
>> 2. fix shared sgpio to support several mcp55 + io55, so every mcp55 have
>>   seperate spinlock
>> 3. use scratch_source as numbering of sgpio instead of address of struct,
>>   so could go through kexec/kdump
>>
>> v2: revert NV_ON and NV_OFF, so turn on Activity LED all the time when
>> disk is idle.
>> v3: use one timer per sgpio instead of per nv_host, so for mcp55+io55
>> system will use 2 timers
>>    instead of 6 timers.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/ata/sata_nv.c |  562
>> ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 562 insertions(+)
>
>
> Is this really over 500 LOC, just to blink some lights from the data xfer
> hot path?  :)
>
there is timer to blink the activity led. per sgpio, normally one for
mcp55 and one for io55.
data xfer hot path only set some status.

YH
