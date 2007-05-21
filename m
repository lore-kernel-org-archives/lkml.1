Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbXEUJJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbXEUJJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755224AbXEUJJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:09:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:57054 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbXEUJJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fA0jOCDnqUP/e7EfGLZMO9s8RWio1JPj+IKhUpZ2w4dMyOJ7M2JcP36YACXj8F7Tr+bEmlGuZZPi+oaCwwaVHz+4IGOL4daNCNpKmjxAApt1OXqpRMoocqbT+jYX7MNuB7LccELnE4RkXpsBDb8UBzESCoBjwh3VDwAdV2cjv/M=
Message-ID: <465161AF.6030002@gmail.com>
Date: Mon, 21 May 2007 11:09:03 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, l.genoni@oltrelinux.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: something strange in libata-core.c for kernel 2.6.22-rc3
References: <fa.MCe9nCgx+WnsHp+weZyM9LiDF0s@ifi.uio.no> <fa.rv8/6n3uBnAIoUHHNUW3eR7cJd8@ifi.uio.no> <fa.LXy58QwLlPXDhsfVUU9kEfA3QbI@ifi.uio.no> <fa.Ldjy2OubeKomZD0OV2gRm/wpUFo@ifi.uio.no> <46515983.6030206@shaw.ca>
In-Reply-To: <46515983.6030206@shaw.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>> Alan, did you have a chance to test the ACPI cable detection?  It just
>> didn't work when I tried it.  It always returned 80c on my machine.
> 
> On a whim I started poking around in the disassembled ACPI DSDT code for
> my Asus A8N-SLI Deluxe board, which is one of these chipsets. The
> original thought was that the STM/GTM trick on these chipsets is
> supposed to allow us to determine what modes we should use based on what
> modes it sets up appropriately. Unfortunately, unless I'm missing
> something in the AML (which is possible) it doesn't seem like there is
> any validation being done on the settings passed in. The settings appear
> to essentially just get programmed into the controller when STM is
> called and read back on GTM.

Yeah, that's consistent to what I've seen on my machine which is a
variant of A8N.  No matter what value I through at _STM, _GTM just
echoed the result thus always leading to 80c configuration.

> I guess this means that what we have to do is trust that the BIOS set up
> a reasonable mode and base the cable detect on that (either by reading
> back the boot-up controller registers, or by calling GTM). I imagine
> this is what the Windows default IDE driver is doing (just using the
> boot-up mode and feeding it back using GTM/STM on suspend/resume cycles).

Alan, what do you think?

-- 
tejun
