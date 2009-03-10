Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbZCJUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbZCJUyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZCJUxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:53:51 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:55274 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZCJUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:53:51 -0400
MIME-Version: 1.0
In-Reply-To: <20090310213811.56f1ca43@hyperion.delvare>
References: <cover.1236702228.git.scott@canonical.com>
	 <20090310184624.4e28d18e@hyperion.delvare>
	 <1236707391.6339.3.camel@quest>
	 <20090310185558.072e6fc6@hyperion.delvare>
	 <1236708806.6339.4.camel@quest>
	 <ac3eb2510903101122h2ff348e8waa3aee20867892fb@mail.gmail.com>
	 <20090310213811.56f1ca43@hyperion.delvare>
Date: Tue, 10 Mar 2009 21:53:47 +0100
Message-ID: <ac3eb2510903101353t1ebdebcfg6d7bef312c79c613@mail.gmail.com>
Subject: Re: [PATCH 00/31] Add a lot of module alias statements
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Scott James Remnant <scott@canonical.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 21:38, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue, 10 Mar 2009 19:22:16 +0100, Kay Sievers wrote:
>> On Tue, Mar 10, 2009 at 19:13, Scott James Remnant <scott@canonical.com> wrote:
>> > On Tue, 2009-03-10 at 18:55 +0100, Jean Delvare wrote:
>> >> On Tue, 10 Mar 2009 17:49:51 +0000, Scott James Remnant wrote:
>> >> > With current modprobe those files are turned into a binary index that
>> >> > can be read and processed *much* faster.
>> >>
>> >> What would prevent the same binary index from being generated from
>> >> user-provided module aliases?
>> >
>> > Why go to all that effort when adding the alias to the kernel is just a
>> > one-line change, and then it shows up along with all of the other
>> > aliases that depmod generates the existing binary index from?
>
> Well, _you_ used the performance improvement as one of the arguments to
> explain why your patches would be good to have. It's only fair to let
> us know if and why there is a relation between where the modalias comes
> from (kernel module or user config) and the possibility to improve
> performance.
>
>> The problem, with a new kernel or module, we know for forever, that we
>> have to run depmod, but this is not the case for depmod config files,
>> and not really to manage, to require a binary index update here.
>
> You are not really clear, sorry. As Scott said before, modprobe is run
> many many times during boot, so it would seem fair to build a binary
> index for all configuration files if it helps with performance. A
> simple time comparison between all configuration files and the index
> should be much faster than parsing all configuration files each time
> modprobe is run, shouldn't it?

It's the long list of fnmatch() calls which is expensive, not the
reading/parsing of the files. It could certainly be implemented, but
it would heavily complicate things. You would need to ignore the
binary index if one config file does not match the current index, or
re-generate it silently, or do other rather complicated stuff to make
things predictable. We would likely better go with a modprobe daemon,
than doing anything like this. But the goal is to have almost no
config files, so we do not need complex optimizations for them. At
least that looks like the best compromise today. :)

>> But the main point is that we want to put information where it
>> belongs: in the module itself. Just look at the crap we ship in
>> /etc/modprobe* and you know that externally maintained configs for
>> kernel modules just don't work. :)
>
> This I certainly agree with (for module aliases which do have an
> interest, that is), no question about that.

Yeah, and there should only be a few things needed. Most of the
content of /etc/modprobe* are missing kernel aliases, module options
which should be made the default in the module, and kernel driver bugs
which should be fixed in the kernel, not in module config files.

Thanks,
Kay
