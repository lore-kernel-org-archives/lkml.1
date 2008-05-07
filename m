Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbYEGTIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbYEGTIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765614AbYEGTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:07:32 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:34302 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765254AbYEGTH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:07:29 -0400
Message-ID: <4821FE2E.9030606@keyaccess.nl>
Date: Wed, 07 May 2008 21:08:30 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26, PAT and AMD family 6
References: <48210A71.1060409@keyaccess.nl>	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>	<4821A7E2.6080101@keyaccess.nl>	<20080507064259.36deb978@infradead.org>	<4821B801.5030508@keyaccess.nl> <20080507072431.30abefae@infradead.org>
In-Reply-To: <20080507072431.30abefae@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07-05-08 16:24, Arjan van de Ven wrote:

> On Wed, 07 May 2008 16:09:05 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:

> [as for which cpus]
> 
> The errata docs have these errata, at least for Intel I know they're
> there. We can add back older cpus over time, but again.. think of it as
> a risk/reward thing ;( Right now, breaking all kinds of well working
> older systems without benefits on the upside.....

What/who do you break, when they are not selecting CONFIG_X86_PAT? The
help text can be suitably alarming. I feel this is no argument at all.

> that's not very popular on lkml. Once PAT is rock solid I hope we can
> relax this check greatly...

A blacklist would seem to be really much preferred. All of AMD family 6
has been excluded in one fell swoop now for example, while I sort of
expect not any of them should be.

>> A blacklist would be a better idea I feel, but in ANY case I think
>> it's really bad form to clear the feature flag. They are provided by
>> hardware; if arch/x86/mm/pat.c won't risk running except on a select
>> few tested models, whatever, but my /proc/cpuinfo shouldn't be lying
>> to me.
> 
> we filter those for all kinds of things already, sorry.
> What good is showing "pat" if "pat" isn't deemed usable (yet)????
> Now *that* is deception :)

The trouble is -- if you hide that the CPU _should_ have PAT, how many
people do you expect are going to look further and test? I knew that I
should have PAT so I distrusted my CPU feature flag display but you've
now limited your testers to people who've read the CPU datasheet.
That's really no good.

If Linux messes around with those flags already, it's doing things
wrong already. /proc/cpuinfo is not a display of software features
but of hardware features -- anything else is outright wrong. Being
wrong for PAT also doesn't improve things.

Rene.
