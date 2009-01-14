Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZANW3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZANW3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZANW3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:29:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:16822 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbZANW3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d3i/Pw4tNDUzPx49RlrEWWBXm/+XcG2ytzBa7QlrIlV/wSQgI4kWJH0Hq9PMf1YfUN
         CSwGosWlNn1jYjk2XkVrDuJ+ED2lMcAQ9LN9fbueS+Onmy45P34LfOBmMsl16YuTy9Vz
         8YJ25vMQjs5WbnraRVoynx6YuVGH6KtOZ/AU4=
Message-ID: <9f4f8abe0901141429l4b111f7bh6ffbc0680ccf4fbc@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:29:20 -0800
From: "Vineet Gupta" <vineetg76@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Query about DMA map API implementation in non-coherent archs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <49686A9E.8090808@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f4f8abe0901091045k4a06e2c9v29a7e8a7387e7a48@mail.gmail.com>
	 <49686A9E.8090808@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 1:30 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> Vineet Gupta wrote:
> ...
>> As per dma-mapping and dma-api docs, for streaming DMA mappings arch
>> needs to provide 2 seperate APIs
>>
>> 1. map API to convert cpu address into DMA address
>> 2. sync API to flush/invalidate the dcaches for non-coherent archs
>> (essentially when changing the ownership of buffer between cpu and
>> device).
>>
>> However from what I understood, the map API need not take care of
>> proper cache sync.However both ARM and MIPS do the cache sync
>> operations in map API as well (this is done standalone in sync APIs
>> too). Is there a specific reason for this.
>>
>> Drivers such as libata don't even call any sync API. For e.g. libata
>> only calls dma_map_sg ( ) while setting up the DMA.
> ...
>
> dma_map_*() transfers ownership of a buffer from CPUs to the device too.
>  In case of DMA_TO_DEVICE or DMA_BIDIRECTIONAL, these calls therefore
> have to make sure that the device sees current buffer contents.

I feel that DMA-api.txt should explicitly say that in part Id, just
before detailing each of the enumerator DMA_TO_DEVICE,
DMA_FROM_DEVICE...

shall I prepare a patch...


> --
> Stefan Richter
> -=====-==--= ---= -=-=-
> http://arcgraph.de/sr/
>
