Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbZF2WLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbZF2WLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbZF2WLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:11:07 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39269 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZF2WLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=H820ac9oM2RQxi/ZUgKdzdc44uAerayx+/MVth31XJzT7phbphtYzo3QaRKZnHg22e
         OFqziY2yQz1Btt3/Vd5qFFSXV8OCmjCGWsdshYutdg3f+x+LfvNsiME5+ozQdSUGbpJ5
         Qlsjm8lSEPDuuzBPucmhHMwTL8NgApgSAuFcI=
Message-ID: <4A493BF9.7010304@gmail.com>
Date: Tue, 30 Jun 2009 00:11:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.5 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Daniel Ribeiro <drwyrm@gmail.com>
CC: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       laforge@openezx.org
Subject: Re: MFD: mutex from ISR in ezx-pcap?
References: <4A49175E.3020409@gmail.com> <1246306840.18231.29.camel@brutus>
In-Reply-To: <1246306840.18231.29.camel@brutus>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 10:20 PM, Daniel Ribeiro wrote:
> Em Seg, 2009-06-29 às 21:34 +0200, Jiri Slaby escreveu:
>> pcap_adc_irq tries to perform non-atomic operations in ISR which is not
>> allowed. Above that, it may deadlock.
>>
>> Since all the operations there (read, write, mutex locking) may sleep,
>> any objections to convert the ISR contents to a workqueue?
> 
> pcap_adc_irq actually already runs from a workqueue (pcap_isr_work).

Aha, thanks, there is a specific irq handler. Ok, sounds fair.

But interrupts are disabled in pcap_isr_work anyway, so that
pcap_adc_irq shouldn't sleep, right? Or maybe I missed something again...
