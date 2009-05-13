Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbZEMSJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbZEMSJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 14:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760124AbZEMSJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 14:09:40 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:53650 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758947AbZEMSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 14:09:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=damore.org;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=q9VA9X8fT5dINDZSMSPW6Jz0zziehQEmkHiM4CrZe2KjecxzH3jVwYQS7z9BA2xwRo1FYWDJExORycTWinV8GSJcOURsZ5zITkpqyRT9ilz1f88etWiS6tVIyuS0NV0F;
Message-ID: <4A0B0CE1.3060309@damore.org>
Date: Wed, 13 May 2009 11:09:37 -0700
From: "Garrett D'Amore" <garrett@damore.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081201)
MIME-Version: 1.0
To: Pierre Ossman <pierre@ossman.eu>
CC: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       SDHCI development <sdhci-devel@lists.ossman.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [Sdhci-devel] Ricoh R5C822 and QUIRK_FORCE_DMA
References: <20090430224524.GA9487@yamamaya.is-a-geek.org> <20090513195956.30f78012@mjolnir.ossman.eu>
In-Reply-To: <20090513195956.30f78012@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2225:box374.bluehost.com:damoreor:damore.org} {sentby:smtp auth 192.18.43.225 authed with garrett+damore.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know that we've run into some bizarre behavior with Ricoh controllers 
and DMA in the Solaris implementation of sdhost.  Specifically, what we 
ran into was problems with DMA across certain alignment boundaries.  It 
seems that when a DMA operation is not aligned on a 512 boundary, or 
does something less than a 512 byte transfer, it has trouble.

In the Solaris driver, I just allocate a big 64k page-aligned chunk for 
DMA, and use bcopy to/from that.  Frankly, bcopy is fast enough, that it 
makes little performance difference.  Plus, it means that I can use a 
larger interrupt threshold than 4K, allowing me to skip the 
scatter/gather overhead... I suspect that this negates the cost of the 
bcopy.

After doing this, the Lenovo and Toshiba laptops that I've had access to 
work well.

    - Garrett

Pierre Ossman wrote:
> (cc:ing sdhci-devel)
>
> On Fri, 1 May 2009 00:45:24 +0200
> Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:
>
>   
>> Do you know any controller bugs for this revision which may be the
>> reason for not advertising DMA capability?
>> I haven't done any big tests yet, but at first glance it seems to
>> read/write the card just fine.
>>
>>     
>
> Might be a system problem so it's Lenovo that disabled it. You're the
> first report I've seen on this since the DMA logic was reworked so that
> DMA didn't have to be forced for most cases.
>
> Is there anyone else reading this that are having DMA problems?
>
> Rgds
>   
> ------------------------------------------------------------------------
>
> _______________________________________________
> sdhci-devel mailing list
> sdhci-devel@lists.ossman.eu
> http://list.drzeus.cx/mailman/listinfo/sdhci-devel
>   

