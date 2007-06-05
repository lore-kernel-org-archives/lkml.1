Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbXFEBkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbXFEBkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 21:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbXFEBj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 21:39:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45631 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXFEBjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 21:39:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	<200706011407.51779.jbarnes@virtuousgeek.org>
	<20070601211943.GO7217@one.firstfloor.org>
	<200706011441.57149.jbarnes@virtuousgeek.org>
	<m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
	<20070604201823.7b7cb328@the-village.bc.nu>
	<m1myzfwi0x.fsf@ebiederm.dsl.xmission.com>
	<86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com>
Date: Mon, 04 Jun 2007 19:38:53 -0600
In-Reply-To: <86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com>
	(Yinghai Lu's message of "Mon, 4 Jun 2007 17:59:59 -0700")
Message-ID: <m1ejkrw576.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> On 6/4/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Exactly, and given that this is a fairly easy thing to do, and that
>> occasionally we see systems where this happens (even if their BIOS is
>> later fixed).  It is likely worth it for someone to write up the patch
>> and that compare MTRRs with available memory, and to complain and
>> reserve all memory that MTRRs claim is not write-back.
>>
> that is good.
> Sometime BIOS can not even keep mtrr to the identical between
> different CPU in SMP system.
>
> Or reset mtrr according to e820 table.

Resetting the mtrrs according to match the e820 table is attractive
and it would be even easier to set the MTRR default type to
write-back, and just handle everything else with PAT.

However that would most likely do horrible things to any BIOS going
into SMI mode, and even a more modest scheme with reprogramming
MTRRs would likely have similar problems, where we put something
in the wrong caching mode.

So the only safe thing we can do is not use memory that is not
write-back cached.  That we can positively detect and is a
conservative action so if anything will work that will.

Eric
