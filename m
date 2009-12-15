Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbZLOXwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbZLOXwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933009AbZLOXwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:52:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41719 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932926AbZLOXwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:52:09 -0500
Message-ID: <4B282189.70202@gmail.com>
Date: Wed, 16 Dec 2009 00:53:45 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Paul Mundt <lethal@linux-sh.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com>	<20091214003836.GD7812@parisc-linux.org>	<4B2595E7.701@gmail.com>	<20091214021916.GB12196@linux-sh.org>	<4B25E47C.1010803@gmail.com>	<20091214123636.GA7417@linux-sh.org>	<4B26BA4A.7080602@gmail.com> <20091214160153.2edfd026@infradead.org>
In-Reply-To: <20091214160153.2edfd026@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 14 Dec 2009 23:20:58 +0100
> Emese Revfy <re.emese@gmail.com> wrote:
> 
>> Paul Mundt wrote:
>>> I don't see anything relating to sparse in that mail. You've
>>> effectively lumped sparse and constification together in the same
>>> camp, but it's unclear why this makes constification a better
>>> option other than that it's simply the option you opted for. All of
>>> your arguments "against" sparse in that context are equally
>>> applicable to constification, so I'll reiterate that you haven't
>>> sufficiently addressed the sparse angle.
>>>
>>> At present you seem to be the only one convinced that
>>> constification is the way to go, despite it being highly intrusive
>>> and ignoring the potential for more favourable and less intrusive
>>> options. You've also failed to adequately address the issues and
>>> suggestsions pointed out by others, and until this happens there is
>>> little point in posting any follow-up patches.
>>>
>>>>> Until such a consensus is reached one way or the other, please
>>>>> refrain from sending hundreds of patches -- one or two are
>>>>> sufficient for showing what you want to do until folks are on
>>>>> board with it, as is the typical nature of mechanical changes.
>>>> I think there is consensus to constify ops variables as much as
>>>> possible (e.g., Alexey's similar patches).
>>>>
>>>> The discussions in these threads were about constifying the ops
>>>> structure fields themselves and I already explained why they are
>>>> useful, see the above link and this one:
>>>> http://lkml.org/lkml/2009/12/8/492
>>> And in here as well in the reply to that mail the same criticism
>>> exists as does the suggestion to look at doing it cleanly in
>>> sparse, which brings us back to what was already mentioned earlier.
>> Let me summarise the discussion so far:
>>
>> As per Al Viro, Arjan and other developers the goal is to force
>> static allocations and prevent runtime modification of ops structures
>> (where it is possible, there are always exceptions like
>> ata_port_operations).
>>
>> The current strategy of constifying variables achieves the second
>> goal only, it still requires human review to catch violations of the
>> first goal.
> 
> this is not correct.
> 
> When the ops variable is const... the compiler will also warn if you
> change it. Make some core APIs use const in their parameter that gets
> a pointer to the ops structure, so that the compiler can optimize.
> That is all goodness.
> 
> But if someone somewhere makes one that is not const.. that's what
> checkpatch.pl is for .. make it warn!
> But don't crap all over structures... I agree with Pavel/Al/etc.. 
> that's bad code without gains.
 
I still think it is a good idea for several reasons (see my last
response to Pavel, http://lkml.org/lkml/2009/12/15/559), but I will
remove the field constifications from the next patch series.

As for splitting up the patches, do you all agree that it should
be one series per structure type at a time (as suggested by Pavel),
with each patch mailed to the respective maintainers? If so, 
how can I reliably determine the maintainers of a given file
without spamming too many people?
--
Emese

