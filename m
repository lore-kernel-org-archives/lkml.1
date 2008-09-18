Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYIRPvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYIRPvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYIRPvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:51:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:6335 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYIRPvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:51:42 -0400
Message-Id: <48D29554.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Thu, 18 Sep 2008 16:52:20 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
References: <48D21BA3.76E4.0078.0@novell.com>
 <20080918071852.GA7639@elte.hu> <20080918091003.GA3751@elte.hu>
 <48D23BF6.76E4.0078.0@novell.com> <48D272F9.3090001@zytor.com>
In-Reply-To: <48D272F9.3090001@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "H. Peter Anvin" <hpa@zytor.com> 18.09.08 17:25 >>>
>Jan Beulich wrote:
>> +
>> +#ifdef CONFIG_X86_32
>> +	if (cpu_has(c, X86_FEATURE_PAE) || cpu_has(c, X86_FEATURE_PSE36))
>> +		c->x86_phys_bits = 36;
>> +#endif
>>  }
>>  
>
>I'm confused about this.
>
>There is no reason for this to be #ifdef'd; but it should be conditional 
>on this information not being otherwise available (which will always be 
>the case on 64 bits), I would assume.  If we are setting a value there, 
>we should presumably also set 32 in the other case.

It does get set to 32 first (and only for 32-bits - 64bits didn't set any
default so far, so I didn't want to make it to now), and the code fragment
above updates that default after feature flags have been obtained, but
before other capabilities (including the phys/virt bit widths) are being
gathered.

Jan

