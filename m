Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab0CFDzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 22:55:19 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59452 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0CFDzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 22:55:17 -0500
MIME-Version: 1.0
In-Reply-To: <20100306002823.GA22095@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru> <20100205203236.GC1475@oksana.dev.rtsoft.ru> 
	<fa686aa41002090913t4c72a3b8o5fda68723bc8d089@mail.gmail.com> 
	<20100209191620.GA24539@oksana.dev.rtsoft.ru> <20100305120015.a2008f46.akpm@linux-foundation.org> 
	<fa686aa41003051228w38579483yd4e95bb8eacf40f7@mail.gmail.com> 
	<20100305123527.d6d68e56.akpm@linux-foundation.org> <fa686aa41003051547u1f499902w1d3efc614a9b20b6@mail.gmail.com> 
	<20100306002823.GA22095@oksana.dev.rtsoft.ru>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 5 Mar 2010 20:54:56 -0700
X-Google-Sender-Auth: a5462f316c124281
Message-ID: <fa686aa41003051954y3ea8ebebxa915efb74c58dcbb@mail.gmail.com>
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
To: avorontsov@ru.mvista.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 5:28 PM, Anton Vorontsov
<avorontsov@ru.mvista.com> wrote:
> On Fri, Mar 05, 2010 at 04:47:06PM -0700, Grant Likely wrote:
> [...]
>> >> I'm not really very comfortable with the whole
>> >> approach being taken.  And, while I acked the first patch in the
>> >> series, that patch isn't needed by anything except patches 2, 3 & 4.
>
> But you didn't answer my replies, ie were sitting silent like for
> a month? So you didn't give my any chance to make them comfortable
> to you.

The last version of the patches were posted on Feb 8.  -rc8 was
released on Feb 12.  For changes to common code, that is a little late
for getting queued up for the merge window.  If it was a subsystem
that I maintain, say SPI, then I doubt I would have picked it up for
2.6.34.

But I am not the GPIO maintainer.  I've stated my case, I'm not fond
of the approach, and I'd rather have another merge cycle before
committing to the method of making OF gpio bindings more generic.  I
missed your request to merge this via the powerpc tree and I had
higher priority concerns, so I really didn't think much of it.  I
assumed that David would look at the arguments and make his own
decision.

For the record, my main concerns are:
- Now that I see the implementation, I think that it is too complex.
The bus notifiers really aren't needed and it can be done with much
lower impact on the core gpiolib code.
- Using notifiers adds an unnecessary race condition, however unlikely.

> Is there any punishment ready for that? ;-) I see one: apply
> these patches, and rework this stuff as you like when you have some
> time?

Changes to common code don't work that way.  Sometimes things just
don't get enough attention and they wait another cycle, get reworked,
or get dropped entirely.

> Or tell me your idea, and I'll do the rework for you, in
> 2.6.35.
>
> But in the meantime, these patches can be nicely used to support
> I2C/SPI GPIO controllers.

...and anyone who need it immediately is welcome to pull your changes
into their private tree.  Skipping a cycle is not the end of the
world.

>> Combine that with the changes being made to drivers/of right now and
>> the addition device tree to ARM and other architectures, my preference
>> is to let this patch series lie fallow for one more merge cycle so
>> that things can settle out in the OF infrastructure code.
>
> How exactly OF rework affects these patches?

For one, the device node pointer is moving out of archdata into
'struct device' proper and I've got patches adding OF hooks into the
core of the platform bus.  If those patches look good to GregKH, then
I'll be pursing the same pattern for the other bus types (i2c, spi,
etc), and it will be further argument for putting the OF hooks
directly into gpiolib instead of using a notifier.  I'll be posting
the patches as soon as the merge window closes.

> And why some rework
> should be used as an excuse for not adding a hardware support?

If this was a standalone device driver then I'd agree.  However, this
is an infrastructure change.  Infrastructure changes get more scrutiny
and are always harder to merge.  Especially just before the merge
window opens with very little linux-next exposure.

g.
