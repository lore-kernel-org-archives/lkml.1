Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZA0T0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZA0T0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZA0T03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:26:29 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46877 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZA0T03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <20090127201406.27c8592f@mjolnir.drzeus.cx>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	 <20090112160519.3ba21848@mjolnir.drzeus.cx>
	 <20090115150003.GB6896@shadowen.org>
	 <20090124185612.5afddbb0@mjolnir.drzeus.cx>
	 <ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
	 <20090125164858.6b281c6c@mjolnir.drzeus.cx>
	 <ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
	 <20090127201406.27c8592f@mjolnir.drzeus.cx>
Date: Tue, 27 Jan 2009 20:26:26 +0100
Message-ID: <ac3eb2510901271126o52eeb867q402d919c3ae6fa56@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 20:14, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Sun, 25 Jan 2009 17:00:11 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Sun, Jan 25, 2009 at 16:48, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
>> >
>> > My point was to have the kernel explicitly ask for the module it wants
>> > as there is no decent device to driver mapping scheme.
>>
>> Yep, which is what we do not want. Aliases are "aliases", and not
>> "module names". We need to add a matching alias to the module then.
>> Direct module names can not properly defined/blacklisted in userspace,
>> and we would need to work around that.
>> Every modalias should be
>> "<subsystem>:<whatever-name-fits-for-the-subsystem>" to plug properly
>> into the autoloading infrastructure. We rather have no modalias at
>> all, then a kernel module name there.
>>
>
> The thing is that asking for a module is the only thing we can do here.
> We can dress it up and give it some special coding to not cause
> problems, but the code will always be "ask userspace to load
> mmc_block", even if we replace "mmc_block" with "mmc:foobargazonk".
>
> Given that, do you have any preferences for a solution? If we cannot
> simply have "mmc_block", then I'm leaning to "mmc:block" for now. The
> contents of the aliases is just an opaque string as far as userspace is
> concerned, right?

Right, it does not matter, we just need to be able to fnmatch()
modalias and the string in the module.

We prefer every modalias to be prefixed with the subsystem, to be able
to hook userspace configs into the alias processing. The string itself
is completely up to the subsystem to decide whatever fits. If there
could ever be several types of strings per susbsystem, it is usual to
prefix the string with some character, but some subsystems know that
this is not needed, and just put a plain single string there.

Thanks,
Kay
