Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYGKO3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYGKO3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 10:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYGKO2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 10:28:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:31518 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYGKO2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 10:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RZ0Ve1KbzVohxcav12y8XZuTTE9yAttn67fYLnXwnhx0tPA95qWmV9IQ+xUCB4Nja/
         pL3oKy1msrOiSMupV35Dgbb4BZ83Q/MJS8JkA+SgnK/LXNXt/KRf+tVgGjD1nZ8c4YQg
         8jz5W2nTO28YJorbl++etcy9+VpnHkAgaRQrQ=
Message-ID: <48776DB2.2020100@gmail.com>
Date: Fri, 11 Jul 2008 16:26:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Char: isicom, enable/disable pci device
References: <1215699612-17909-1-git-send-email-jirislaby@gmail.com> <20080710163515.7d112a87.akpm@linux-foundation.org>
In-Reply-To: <20080710163515.7d112a87.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2008 01:35 AM, Andrew Morton wrote:
> On Thu, 10 Jul 2008 16:20:12 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
>> --- a/drivers/char/isicom.c
>> +++ b/drivers/char/isicom.c
>> @@ -1736,6 +1736,12 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
>>  	if (card_count >= BOARD_COUNT)
>>  		goto err;
>>  
>> +	retval = pci_enable_device(pdev);
>> +	if (retval) {
>> +		dev_err(&pdev->dev, "failed to enable\n");
>> +		goto err;
>> +	}
>> +
[...]
> hm.  Is this a recently-added problem?

It disappeared in 2.6.16 (9ac0948): char/isicom: Pci probing added (by me).

> I wonder what the chance is that this will fix something.  Or break
> something.

This is what pci documentation says:
<cite>
3.1 Enable the PCI device
~~~~~~~~~~~~~~~~~~~~~~~~~
Before touching any device registers, the driver needs to enable
the PCI device by calling pci_enable_device(). This will:
         o wake up the device if it was in suspended state,
         o allocate I/O and memory regions of the device (if BIOS did not),
         o allocate an IRQ (if BIOS did not).
</cite>
Maybe Jesse can tell us more on what effect might have device enable omitting?
