Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbXI0SQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbXI0SQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXI0SQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:16:46 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:8285 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbXI0SQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:16:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hCBCtFEKcQw0qcMgggDYAVnBcDvmV0AS+HoXPpiYu2aMfxTHy6Wbk9XlELXIixTjU3lywzXuqhVuqgpmiceyX18SNGhGXhnF8smWgswuMi6JMr6pudvd4sDOkFURRnz0CYzhV0R/PgOoLv4N0oinVYprTJYN2OW18gKXVa1PG/k=
Message-ID: <46FB563A.80108@gmail.com>
Date: Thu, 27 Sep 2007 16:05:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, michal.k.k.piotrowski@gmail.com,
       bryan@arbores.ca, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com> <20070905095327.6277d054.akpm@linux-foundation.org> <46DEE617.4050004@rtr.ca> <46E0A253.7060803@gmail.com> <46E154DE.2060602@rtr.ca>
In-Reply-To: <46E154DE.2060602@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Tejun Heo wrote:
>> Hello,
>>
>> Mark Lord wrote:
>>> I reported a very similar bug back a few releases ago.
>>> Anyone who wants to try it themselves, can do this with hdparm-7.7 (from
>>> sourceforge):
>>>
>>>    hdparm --drq-hsm-error /dev/sda
>>>
>>> Whether or not it hangs the machine does depend upon exactly which SATA
>>> LLD is used,
>>> and what model/revision of drive is installed.  But if it hangs for you
>>> (eg. Tejun),
>>> then you now have a way to reproduce a HSM error "on demand" for
>>> testing.  :)
>>
>> Neat.  Is this the FIFO-draining issue?
> 
> Yeah, that's the one.  And I still patch my own kernels to
> automatically drain up to 512 words from the FIFO when this happens.
> 
> Works like a charm.  Patch below for demonstration purposes.
> 
> Signed-Off-By:  Mark Lord <mlord@pobox.com>

I think there have been enough cases where this draining was necessary.
 IIRC, ata_piix was involved in those cases, right?  If so, can you
please submit a patch which applies this only to affected controllers?
I don't feel too confident about applying this to all SFF controllers.

Thanks.

-- 
tejun

