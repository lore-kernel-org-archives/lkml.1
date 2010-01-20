Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473Ab0ATMAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0ATMAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352Ab0ATMAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:00:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab0ATMAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:00:42 -0500
Message-ID: <4B56F040.1080703@redhat.com>
Date: Wed, 20 Jan 2010 14:00:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <1262700774-1808-5-git-send-email-gleb@redhat.com> <1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com> <4B541D08.9040802@zytor.com> <20100118085022.GA30698@redhat.com> <4B5510B1.9010202@zytor.com> <20100119065537.GF14345@redhat.com> <4B55E5D8.1070402@zytor.com> <20100119174438.GA19450@redhat.com> <4B5611A9.4050301@zytor.com> <20100120100254.GC5238@redhat.com>
In-Reply-To: <20100120100254.GC5238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 12:02 PM, Gleb Natapov wrote:
>
> I can inject the event as HW interrupt on vector greater then 32 but not
> go through APIC so EOI will not be required. This sounds non-architectural
> and I am not sure kernel has entry point code for this kind of event, it
> has one for exception and one for interrupts that goes through __do_IRQ()
> which assumes that interrupts should be ACKed.
>    

Further, we start to interact with the TPR; Linux doesn't use the TPR or 
cr8 but if it does one day we don't want it interfering with apf.

-- 
error compiling committee.c: too many arguments to function

