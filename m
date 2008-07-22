Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYGVRL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYGVRL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYGVRLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:11:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38060 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbYGVRLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:11:06 -0400
Message-ID: <488614A3.1060400@garzik.org>
Date: Tue, 22 Jul 2008 13:10:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
 boot
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>	 <48848DDF.6010903@zytor.com>	 <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>	 <48851AC2.8030007@zytor.com> <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com>
In-Reply-To: <43e72e890807212147p5d19cfact17e719abb338378c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> On Mon, Jul 21, 2008 at 4:24 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Luis R. Rodriguez wrote:
>>> On Mon, Jul 21, 2008 at 6:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> Luis R. Rodriguez wrote:
>>>>> This bug seems to be present since 2.6.22 [1], so hope we can get this
>>>>> fixed ASAP. Let me know if you have patch suggestions I can test.
>>>>>
>>>>> This crashes very early, I had to use earlyprintk to get it.
>>>>>
>>> I've put extra spaces between the culprit.
>>>
>>> c0387ac2:       0f 1f 40 00             nopl   0x0(%eax)
>>>
>> Sure enough, our old friend.
>>
>> You have in your configuration:
>>
>> CONFIG_M686=y
>> # CONFIG_X86_GENERIC is not set
>>
>> ... so this is fully expected; CONFIG_M686 without CONFIG_X86_GENERIC is not
>> compatible with such processors.
>>
>> Not a bug.
> 
> Thanks for taking a  look at this. So well, it would be a
> misconfiguration bug by the distribution then to try to support a
> generic 686 kernel wihtout GENERIC then.

Well, it may be intentional -- some distros simply exclude support for 
the lower-volume VIA processors, since that might imply building their 
"generic 686 kernel" sans CMOV and some other instructions, and changing 
the compiler's instruction scheduling to something less optimal for the 
majority.  :/

	Jeff



