Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbYGDUtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbYGDUtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYGDUtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:49:24 -0400
Received: from mail.macqel.be ([194.78.208.39]:1494 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYGDUtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:49:23 -0400
Date: Fri, 4 Jul 2008 22:49:19 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee1394 : dump mmapped video1394 buffers in core files
Message-ID: <20080704204919.GA8991@frolo.macqel>
References: <20080701132149.GA32510@frolo.macqel> <517f3f820807011116g6ce1b3e1qf166070f7a4c523f@mail.gmail.com> <20080702105027.GA1111@frolo.macqel> <cfd18e0f0807020358k317575c6ra0187428098f0160@mail.gmail.com> <486C4CC5.2060006@hitachi.com> <20080703093736.GA14369@frolo.macqel> <20080703165228.GA29373@frolo.macqel> <486E6CED.8060309@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486E6CED.8060309@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 08:33:17PM +0200, Stefan Richter wrote:
> Philippe De Muyter wrote:
>> Currently, core files do not contain the mmapped memory of the video1394
>> or dv1394 devices,
>
> Ditto with /dev/raw1394 when the rawiso ioctl API is used.
>
>> which contain the actual video input, making it
>> impossible to analyse the cause of abnormal program termination for
>> image analysis or (de)compression software.  Fix that.
>> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
>> ---
>> diff -r ced66ca0044f drivers/ieee1394/dma.c
>> --- a/drivers/ieee1394/dma.c	Mon Jun 30 08:58:09 2008 -0700
>> +++ b/drivers/ieee1394/dma.c	Thu Jul  3 18:40:24 2008 +0200
>> @@ -274,7 +274,7 @@ int dma_region_mmap(struct dma_region *d
>>  	vma->vm_ops = &dma_region_vm_ops;
>>  	vma->vm_private_data = dma;
>>  	vma->vm_file = file;
>> -	vma->vm_flags |= VM_RESERVED;
>> +	vma->vm_flags |= VM_RESERVED | VM_ALWAYSDUMP;
>>   	return 0;
>>  }
>
> I'll commit it with the title changed to "dump mmapped iso buffers in core 
> files" if that's OK.

OK for me

Philippe
