Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZGAG42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZGAG42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 02:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZGAG4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 02:56:21 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57395 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZGAG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 02:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rCBm/ZXgQ0stkZtwUKv7ByolWn6YnR2111ITehF8CgyIHqLNceC8bXh/mjKJ5BZBhW
         q99PmayRDXf0XYPp+/cheE5AKLAwIGW2bLhlWvbOhuPt8NdPbbye77WFHezF5x4F+SLm
         0giThgDHmcA5wGLQK28Bu5DmEVjx7v0es8YaU=
Message-ID: <4A4B088A.9030905@gmail.com>
Date: Wed, 01 Jul 2009 08:56:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.7 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Daniel Ribeiro <drwyrm@gmail.com>
CC: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       laforge@openezx.org
Subject: Re: MFD: mutex from ISR in ezx-pcap?
References: <4A49175E.3020409@gmail.com> <1246306840.18231.29.camel@brutus>	 <4A493BF9.7010304@gmail.com> <1246352256.18231.408.camel@brutus>
In-Reply-To: <1246352256.18231.408.camel@brutus>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2009 10:57 AM, Daniel Ribeiro wrote:
> Em Ter, 2009-06-30 às 00:11 +0200, Jiri Slaby escreveu: 
>> so that
>> pcap_adc_irq shouldn't sleep, right? Or maybe I missed something again...
> 
> No. Interrupts are enabled again before pcap_adc_irq() runs.
> 
> pcap_isr_work() doesn't call pcap_adc_irq directly, it calls the
> irq_flow_handler, handle_simple_irq(), which needs to run with
> interrupts disabled. Interrupts are enabled again on handle_IRQ_event(),
> as pcap_adc_irq is requested _without_ IRQF_DISABLED.

Correct. Thanks for clarification. I posted at least a lock fix which
made me poke in this all.
