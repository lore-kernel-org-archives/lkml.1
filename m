Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYE2SmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYE2SmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYE2Sl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:41:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:48506 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYE2Sl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oxEdc1Tg7CIKQSnnni8YKTPRNDOdpjiZRxRXU1PAuTaQDgheR5OGcHE0QFgCippnpGq1+RufZVUSGJnDcA1QNvPFEuJkjpZ2Nb3DIFf/JiCOdb/NTgtk4fFLsKgAAOO0OVyJFMwY/xxPNq8vK72GtwXwSs3OEgkRugt6m7yw9yU=
Message-ID: <86802c440805291141i7fdc73e8p56e4728996337abc@mail.gmail.com>
Date: Thu, 29 May 2008 11:41:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <483EB18F.4070105@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805110030.15510.yhlu.kernel@gmail.com>
	 <483C70F9.2030901@goop.org>
	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>
	 <483C7BB0.6080901@goop.org>
	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>
	 <483C8157.7080702@goop.org>
	 <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>
	 <483D2D8A.5040800@goop.org>
	 <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>
	 <483EB18F.4070105@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 6:37 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>>
>> can we use e820 entries for that? So the domain builder could have
>> several entries for E820_RAM and E820_RESERVED...
>>
>
> I tried this, but it doesn't work; the kernel crashes during boot,
> presumably because it's trying to use the reserved memory as heap.  I
> suspect the e820 maps are not registered early enough or something...
>
> (One thought: if reserving in the E820 map were enough, then couldn't we use
> it for all the early reservations?)

"e820 reserved entries" means kernel will only read it.

reserve_early will be converted to bootmem via reserve_bootmem[_generic]
and later it could be freed and be reused.

YH
