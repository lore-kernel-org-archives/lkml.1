Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbXETW2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbXETW2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757537AbXETW1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:27:53 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63437 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbXETW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:27:53 -0400
Date: Sun, 20 May 2007 16:27:42 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
In-reply-to: <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: l.genoni@oltrelinux.com
Message-id: <4650CB5E.3010603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.MCe9nCgx+WnsHp+weZyM9LiDF0s@ifi.uio.no>
 <fa.rv8/6n3uBnAIoUHHNUW3eR7cJd8@ifi.uio.no>
 <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no>
 <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> l.genoni@oltrelinux.com wrote:
>> Mybe I am wrong, but if you are detecting 40-wire cable to set them to
>> DMA/33, why the check includes also 80-wire cables configuring them to
>> DMA/33 too?
>>
>> With this patch my nvidia4 IDE controllers detects correctly and
>> configure correctly DMA/100 for my HD and DMA/33 for my DVD (the first
>> uses a 80-wire cable, the second a 40-wire cable).
>>
>> Am I wrong somewhere?
> 
> That's the drive side verification of 80c cable check, so if the
> condition triggers we downgrade 80c or unknown to 40c.  Cable detection
> on nvidia PATA is a disaster.  You're supposed to do some ACPI dancing
> and drive side detection is completely bogus.  Eeeek....
> 
> Alan, did you have a chance to test the ACPI cable detection?  It just
> didn't work when I tried it.  It always returned 80c on my machine.

Hopefully when we get that support in and working it will solve a lot of 
these issues (and others, like the laptops that have a short 40-wire 
cable that is good for high UDMA speeds which we presently have to 
hard-code detection for specific models).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

