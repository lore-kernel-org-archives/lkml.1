Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZEZRYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZEZRYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZEZRYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:24:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:32307 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZEZRYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VBMmLd7R+GDertmgATTbRvRAkc7MJfOEiM56nhd7z399kRzY4E4fhs4aVRnC6NA+7t
         LVayT3nIflnnwhr/qa21r/TAIT0KMBvYdZDuZC6qNdsmdYjHqJx3YyCNSLdWAkeaagb6
         QMXfH4CMkGsDC3MyemkHBzGIRAc/Zl2TYWc/Y=
MIME-Version: 1.0
In-Reply-To: <20090526170653.GB24261@linux-sh.org>
References: <1243331191-11445-1-git-send-email-vapier@gentoo.org>
	 <1243331191-11445-2-git-send-email-vapier@gentoo.org>
	 <20090526113122.GB16835@linux-sh.org>
	 <8bd0f97a0905260942m4b574d75oc4f38ee3d8849395@mail.gmail.com>
	 <20090526164735.GA24261@linux-sh.org>
	 <8bd0f97a0905260950i6da64210n7da256627d3e38ff@mail.gmail.com>
	 <20090526170653.GB24261@linux-sh.org>
Date: Tue, 26 May 2009 13:24:46 -0400
Message-ID: <8bd0f97a0905261024q178fbc80n4a997daca5a3b405@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd/maps: uclinux: support Blackfin systems
From: Mike Frysinger <vapier.adi@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 13:06, Paul Mundt wrote:
> On Tue, May 26, 2009 at 12:50:51PM -0400, Mike Frysinger wrote:
>> On Tue, May 26, 2009 at 12:47, Paul Mundt wrote:
>> > On Tue, May 26, 2009 at 12:42:48PM -0400, Mike Frysinger wrote:
>> >> > In this case you should just kill all of that crap off, and have the
>> >> > platforms that use this set uclinux_ram_map up themselves, it's already
>> >> > a global. Of course you can use _ebss as a default value for
>> >> > uclinux_ram_map.phys and just override it in your platform.
>> >>
>> >> i would agree if it were a board-specific issue, but it's an arch
>> >> issue, so pushing it to the boards level is wrong. ??i can however
>> >> replace the addr with a global weak and add a symbol into the Blackfin
>> >> arch code to override it.
>> >>
>> > I obviously meant architectures setting up the address, not the board
>> > code, as this has nothing at all to do with boards. There are already
>> > plenty of cases in setup_arch() for filling in uclinux mtd data, one more
>> > isn't going to make a difference.
>> >
>> > I don't see anything wrong with keeping uclinux_ram_map as a global
>> > however, particularly since platforms that need to special case the
>> > mapping can easily do this under the existing ifdef. Adding weak symbols
>> > for something like this just seems silly.
>>
>> the point of the weak symbol was so that the map could provide a sane
>> default that works for most everyone out there without having to copy
>> & paste the same code to every arch, and to make new arch porters
>> worry about what needs to be done to use this very trivial map
>
> Did you purposely only read the parts of my email that you felt like?
> Note the original quoted part that mentions using _ebss as a default and
> simply overriding it in your platform.

if i wanted to piss you off, i imagine that would be what i was doing.
 but considering my purpose is to get merged, there's a more logical
conclusion.  we envisioned different solutions, so having the ideas in
our minds not line up isnt terribly surprising.

> Use the attached, and then just set uclinux_ram_map.phys = your_address_here
> in your setup_arch(). Having weak symbols in drivers that are supposed to
> be overriden by the architecture code is just way too backwards for
> words. Globals suffice fine for this sort of thing, if you are not going
> to go to the effort to pass this information to the driver directly that
> is.

i was thinking something else, but obviously this is nicer than what i
was thinking
-mike
