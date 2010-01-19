Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323Ab0ASB7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0ASB7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 20:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151Ab0ASB7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 20:59:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab0ASB7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 20:59:09 -0500
Message-ID: <4B5510B1.9010202@zytor.com>
Date: Mon, 18 Jan 2010 17:53:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 04/12] Add "handle page fault" PV helper.
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <1262700774-1808-5-git-send-email-gleb@redhat.com> <1263490267.4244.340.camel@laptop> <20100117144411.GI31692@redhat.com> <4B541D08.9040802@zytor.com> <20100118085022.GA30698@redhat.com>
In-Reply-To: <20100118085022.GA30698@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:50 AM, Gleb Natapov wrote:
> On Mon, Jan 18, 2010 at 12:34:16AM -0800, H. Peter Anvin wrote:
>> On 01/17/2010 06:44 AM, Gleb Natapov wrote:
>>> On Thu, Jan 14, 2010 at 06:31:07PM +0100, Peter Zijlstra wrote:
>>>> On Tue, 2010-01-05 at 16:12 +0200, Gleb Natapov wrote:
>>>>> Allow paravirtualized guest to do special handling for some page faults.
>>>>>
>>>>> The patch adds one 'if' to do_page_fault() function. The call is patched
>>>>> out when running on physical HW. I ran kernbech on the kernel with and
>>>>> without that additional 'if' and result were rawly the same:
>>>>
>>>> So why not program a different handler address for the #PF/#GP faults
>>>> and avoid the if all together?
>>> I would gladly use fault vector reserved by x86 architecture, but I am
>>> not sure Intel will be happy about it.
>>>
>>
>> That's what it's there for... see Peter Z.'s response.
>>
> Do you mean I can use one of exception vectors reserved by Intel
> (20-31)? What Peter Z says is that I can register my own handler for
> #PF and avoid the 'if' in non PV case as far as I understand him.
> 

What I mean is that vector 14 is page faults -- that's what it is all
about.  Why on Earth do you need another vector?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

