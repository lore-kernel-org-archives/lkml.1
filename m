Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759Ab0ASRHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab0ASRHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711Ab0ASRHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:07:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab0ASRHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:07:46 -0500
Message-ID: <4B55E5D8.1070402@zytor.com>
Date: Tue, 19 Jan 2010 09:03:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <1262700774-1808-5-git-send-email-gleb@redhat.com> <1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com> <4B541D08.9040802@zytor.com> <20100118085022.GA30698@redhat.com> <4B5510B1.9010202@zytor.com> <20100119065537.GF14345@redhat.com>
In-Reply-To: <20100119065537.GF14345@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 10:55 PM, Gleb Natapov wrote:
>>
>> What I mean is that vector 14 is page faults -- that's what it is all
>> about.  Why on Earth do you need another vector?
>>
> Because this is not usual pagefault that tell the OS that page is not
> mapped. This is a notification to a guest OS that the page it is trying
> to access is swapped out by the host OS. There is nothing guest can do
> about it except schedule another task. So the guest should handle both
> type of exceptions: usual #PF when page is not mapped by the guest and
> new type of notifications. Ideally we would use one of unused exception
> vectors for new type of notifications.
> 

Ah, this kind of stuff.  We have talked about this in the past, and the
right way to do that is to have the guest OS pick a vector our of the
standard 0x20-0xff range, and then notify the hypervisor via a hypercall
which vector to use.

In Linux this means marking it as a system vector.  Note that there are
real hardware system vectors which will be mutually exclusive with this,
e.g. the UV one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

