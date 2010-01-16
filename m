Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751169Ab0APFDc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 00:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865Ab0APFDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 00:03:30 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44164 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab0APFDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 00:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iw12Ys45xlQtedJ/t6k7kSNaWOvl2rkebmQLfQL69VDJalJ8JKBYRJbQI6pjn3loGq
         BCA/Qoefoe8bzCj1CGIq+0N/VeimWdTEAFVn5zspuA1TiDlH4E2ergIl05iZ97gBkkUh
         lx7zjiP0SYl/KKoIAH/P6uDje9Yr7rjDo9Vrc=
Message-ID: <4B51489F.8010105@gmail.com>
Date: Fri, 15 Jan 2010 23:03:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL on IXP425 workaround
References: <m33a4nfvva.fsf@intrepid.localdomain>	<201001141659.19687.bzolnier@gmail.com>	<20100114192210.62593ead@lxorguk.ukuu.org.uk>	<m3my0gh2dc.fsf@intrepid.localdomain> <20100114210515.7a477a43@lxorguk.ukuu.org.uk>
In-Reply-To: <20100114210515.7a477a43@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2010 03:05 PM, Alan Cox wrote:
>> We need to use the MMIO BAR at least for starting DMA transfers, the
>> I/O ones are 64KB-limited. We can't just use read[bw] if reading all
>> 32 bits has side effects.
>
> Last time I instrumented this on x86 we never issued a>  64K linear block
> in our s/g lists. In fact we went for years before anyone noticed we had
> a bug with CS5530 and a couple of other chips that mishandled 64K segment
> sizes, and that was only finally noticed in a very specific and weird
> circumstance.

Having a block over 64KB may be rare, but the other thing that the large 
block transfer feature does is remove the restriction on a block 
crossing a 64KB boundary, which based on the experiments I did when I 
worked on adding the feature, does happen fairly commonly if the driver 
allows it.
