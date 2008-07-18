Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYGRMhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYGRMhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYGRMhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:37:12 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:54090 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbYGRMhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:37:10 -0400
Message-ID: <48808EEC.3000409@keyaccess.nl>
Date: Fri, 18 Jul 2008 14:39:08 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
CC: Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rene Herman <rene.herman@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [boot crash, bisected] in 9f240a55 "ALSA: opti93x: use cs4231
 lib"
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz>	<20080717170657.GA14593@elte.hu>	<s5h3am8jqvy.wl%tiwai@suse.de>	<487F9B9B.2010905@keyaccess.nl>	<487F9FA1.7020101@keyaccess.nl>	<48806017.1040307@keyaccess.nl> <20080718142849.f11ce4c8.krzysztof.h1@poczta.fm> <48808E39.4060404@keyaccess.nl>
In-Reply-To: <48808E39.4060404@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-07-08 14:36, Rene Herman wrote:

> On 18-07-08 14:28, Krzysztof Helt wrote:
> 
>> On Fri, 18 Jul 2008 11:19:19 +0200
>> Rene Herman <rene.herman@keyaccess.nl> wrote:
>>
>>> On 17-07-08 21:38, Rene Herman wrote:
>>>
>>>> On 17-07-08 21:20, Rene Herman wrote:
>>>>
>>>>> On 17-07-08 20:40, Takashi Iwai wrote:
>>>>>
>>>>>> Could you try the patch below?
>>> This bug was uncovered by !CONFIG_PNP and we had trouble in this 
>>> driver due to that before so was rewriting the init to be a generic 
>>> multi-card ALSA init but, actually, not much point.
>>>
>>
>> The bug was introduced by the patch as it used (tried to free) the 
>> codec pointer
>> before it was assigned any value. It happened only if the card was 
>> missing and
>> I didn't test the driver on such a configuration. My mistake. The 
>> CONFIG_PNP
>> setting makes no difference.
> 
> Yes it does. Note how the ISA match method fails due to "if (isapnp)" 
> with CONFIG_PNP and isapnp being initialized to 1. I did test without 
> the hardware but didn't see it fail due to that.

(but please note, yes, "uncovered", not "caused". the bug was indeed in 
this commit and was fixed by Takashi).

Rene.

