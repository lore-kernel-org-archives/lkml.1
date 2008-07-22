Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYGVNOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYGVNOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYGVNO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:14:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYGVNO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:14:26 -0400
Date: Tue, 22 Jul 2008 15:14:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
	boot
Message-ID: <20080722131408.GA12418@elte.hu>
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com> <48848DDF.6010903@zytor.com> <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com> <48851AC2.8030007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48851AC2.8030007@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin <hpa@zytor.com> wrote:

> Luis R. Rodriguez wrote:
>> On Mon, Jul 21, 2008 at 6:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Luis R. Rodriguez wrote:
>>>> This bug seems to be present since 2.6.22 [1], so hope we can get this
>>>> fixed ASAP. Let me know if you have patch suggestions I can test.
>>>>
>>>> This crashes very early, I had to use earlyprintk to get it.
>>>>
>>
>> I've put extra spaces between the culprit.
>>
>> c0387ac2:       0f 1f 40 00             nopl   0x0(%eax)
>>
>
> Sure enough, our old friend.
>
> You have in your configuration:
>
> CONFIG_M686=y
> # CONFIG_X86_GENERIC is not set
>
> ... so this is fully expected; CONFIG_M686 without CONFIG_X86_GENERIC is  
> not compatible with such processors.
>
> Not a bug.

it would still be nice to get a nice printk and panic during bootup 
instead of some obscure crash, hm?

	Ingo
