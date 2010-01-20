Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670Ab0ATSs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0ATSs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303Ab0ATSs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:48:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57316 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0ATSs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:48:56 -0500
Message-ID: <4B574F2E.8080402@zytor.com>
Date: Wed, 20 Jan 2010 10:45:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <1262700774-1808-5-git-send-email-gleb@redhat.com> <1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com> <4B541D08.9040802@zytor.com> <20100118085022.GA30698@redhat.com> <4B5510B1.9010202@zytor.com> <20100119065537.GF14345@redhat.com> <4B55E5D8.1070402@zytor.com> <20100119174438.GA19450@redhat.com> <4B5611A9.4050301@zytor.com> <20100120100254.GC5238@redhat.com> <4B56F040.1080703@redhat.com>
In-Reply-To: <4B56F040.1080703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 04:00 AM, Avi Kivity wrote:
> On 01/20/2010 12:02 PM, Gleb Natapov wrote:
>>
>> I can inject the event as HW interrupt on vector greater then 32 but not
>> go through APIC so EOI will not be required. This sounds
>> non-architectural
>> and I am not sure kernel has entry point code for this kind of event, it
>> has one for exception and one for interrupts that goes through __do_IRQ()
>> which assumes that interrupts should be ACKed.
>>    
> 
> Further, we start to interact with the TPR; Linux doesn't use the TPR or
> cr8 but if it does one day we don't want it interfering with apf.
> 

I don't think the TPR would be involved unless you involve the APIC
(which you absolutely don't want to do.)  What I'm trying to figure out
is if you could inject this vector as "external interrupt" and still
have it deliver if IF=0, or if it would cause any other funnies.

As that point, you do not want to go through the do_IRQ path but rather
through your own exception vector entry point (it would be an entry
point which doesn't get an error code, like #UD.)

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

