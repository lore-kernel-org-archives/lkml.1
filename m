Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZAYQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZAYQA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 11:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZAYQAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 11:00:16 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:60008 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbZAYQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 11:00:15 -0500
MIME-Version: 1.0
In-Reply-To: <20090125164858.6b281c6c@mjolnir.drzeus.cx>
References: <1231268198-12556-1-git-send-email-apw@canonical.com>
	 <20090112160519.3ba21848@mjolnir.drzeus.cx>
	 <20090115150003.GB6896@shadowen.org>
	 <20090124185612.5afddbb0@mjolnir.drzeus.cx>
	 <ac3eb2510901241545l4eb9f77dvebd5861340b3447e@mail.gmail.com>
	 <20090125164858.6b281c6c@mjolnir.drzeus.cx>
Date: Sun, 25 Jan 2009 17:00:11 +0100
Message-ID: <ac3eb2510901250800g40dd31d8q35e626413f2853a1@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmc: add MODALIAS linkage for MMC/SD devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 16:48, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
> On Sun, 25 Jan 2009 00:45:46 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Sat, Jan 24, 2009 at 18:56, Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:
>> >
>> > Well, as long as we're on the track of temporary hack, we might as well
>> > just export "mmc_block" as the modalias. Or would there be any
>> > side-effects to that?
>>
>> The common format is to prefix with "<subsystem>:". Something like
>> "mmc:block" sounds fine to me.
>>
>
> My point was to have the kernel explicitly ask for the module it wants
> as there is no decent device to driver mapping scheme.

Yep, which is what we do not want. Aliases are "aliases", and not
"module names". We need to add a matching alias to the module then.
Direct module names can not properly defined/blacklisted in userspace,
and we would need to work around that.
Every modalias should be
"<subsystem>:<whatever-name-fits-for-the-subsystem>" to plug properly
into the autoloading infrastructure. We rather have no modalias at
all, then a kernel module name there.

Thanks,
Kay
