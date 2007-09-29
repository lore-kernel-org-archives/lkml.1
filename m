Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbXI2Me2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbXI2Me2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 08:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbXI2MeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 08:34:20 -0400
Received: from rtr.ca ([76.10.145.34]:4619 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbXI2MeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 08:34:19 -0400
Message-ID: <46FE464A.4020808@rtr.ca>
Date: Sat, 29 Sep 2007 08:34:18 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata drain fifo on stuck DRQ HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca>	<46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca>	<46FB563A.80108@gmail.com>	<20070927193701.6230d77f@the-village.bc.nu>	<46FC3D7D.90009@gmail.com>	<46FC3FDD.5060201@pobox.com>	<46FC423C.2050206@gmail.com>	<46FC7B72.2030103@rtr.ca>	<20070928112735.264733ad@the-village.bc.nu>	<46FDA4F3.7050205@pobox.com> <20070929072831.2df5f5ed@the-village.bc.nu>
In-Reply-To: <20070929072831.2df5f5ed@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> Why 512 words ?
>> Though I have queued Mark's patch to be applied, my gut feeling would 
>> lean towards a single DRQ block, rather than 512.
> 
> Why not just work from the old IDE code.
>>
>>>>  	ata_altstatus(ap);
>>>> -	ata_chk_status(ap);
>>>> +	ata_drain_fifo(ap, qc);
>>> ap->ops->cleanup();
>>>
>>> might be wiser
>> If someone needs that, they can override the error handler with their 
>> own.  No need for a new op.
> 
> PDC202xx needs

Alan, you're the expert there (my condolences!).
Can you generate a fix for the PDC202xx to go with this?

Cheers
