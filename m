Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZFTXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZFTXKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZFTXKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 19:10:34 -0400
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:42419
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751021AbZFTXKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 19:10:34 -0400
Date: Sat, 20 Jun 2009 19:10:34 -0400
From: Sean MacLennan <smaclennan@pikatech.com>
To: Frans Pop <elendil@planet.nl>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Badness on the Warp
Message-ID: <20090620191034.48fa085a@lappy.seanm.ca>
In-Reply-To: <200906202256.46073.elendil@planet.nl>
References: <20090620154824.72b5cd50@lappy.seanm.ca>
	<200906202256.46073.elendil@planet.nl>
Organization: PIKA
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAHlBMVEXOy8P+/f8hHBFoOhetjm76/P5qPzJLJxltXUSaX0wbgtjEAAACY0lEQVQ4jWWUQWvcMBCF91BCjiuIIWcX6nsE9uZWgknjWwW7sD2rjL1XGzzpNS2ufI5xVv+2byTHSehcbO8nzWjeG+1GqcPhZfTlEl8/hUdVbgDUvfNT+SEqH8Ho/UdQCjDJg0dMceVUhVcBKhn8Go7qTjd4CYCcBL7OQ9GmGXfNuICauaNmIKrbNGWivAngQPhMOScibODGOZ2PYUfdMlCnyTJWpFlu9SkW14Ps6cdZHoJ4F4ENPzxOD3i2cZMA9VCHdV/KCmdC3i7WMAKyNuNfZVUwzoA2pmqjDkZd1ikjfpblTDj32PhSwEH9GHTBrQDvpaXT9Aqc1cz9HwHedg20qkLxK2cLNIh1q8p+Ae53TsMJ36shAewdDPHz+B/YDqOffEhTvXMQYIbp0SppIdQKIIG31XwK4Pk2OrYAuGQX0JHUowDUPY1O77xkeob6CLsxYQfZvMhxNJhYsNY56bjjktA6Pgl6WIiLiOC6g1hQltMMIJBY/FrEhcRisIWcrG3csa8DEOt6pGs5HwIw2zrkCW6TCN0sQP2tuwjSmouWb10EiXrJcUwhqAzfx2aWaYe5F48k9qbBYplKFybRmGPvbuJIyUTKTAagkquabrJWcnV0OqONqFWSfH/qi52cDOvHs10bVOobgEb73NPoh1WSJDky72whkmDcVmCkCMuJU9Yn/y6VMWaGriTTiesmUxZTIS4yOIR5qPzZSbMr2LefcaB4P/V7kNxlvcY9xJnEQ70Cc2w7aCFXtBCnVqC2uCEiU2hz6TxuuUsz0TDy/C1Vcgwayh8AwFvxg9k/LTcWUfA/se5dIXIv87sAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jun 2009 22:56:45 +0200
Frans Pop <elendil@planet.nl> wrote:

> The fact that your bisect ended at a merge essentially means that it
> is invalid. As a merge does not introduce any actual change (unless
> it includes changes to resolve conflicts), it normally cannot be the
> cause of a regression.

Makes sense I messed up somewhere. This is the commit that causes
problems:

Merge branch 'topic/slab/earlyboot' of git://git./linux/kernel/git/penberg/slab-2.6


* 'topic/slab/earlyboot' of git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6:

  vgacon: use slab allocator instead of the bootmem allocator

  irq: use kcalloc() instead of the bootmem allocator

  sched: use slab in cpupri_init()

  sched: use alloc_cpumask_var() instead of alloc_bootmem_cpumask_var()

  memcg: don't use bootmem allocator in setup code

  irq/cpumask: make memoryless node zero happy

  x86: remove some alloc_bootmem_cpumask_var calling

  vt: use kzalloc() instead of the bootmem allocator

  sched: use kzalloc() instead of the bootmem allocator

  init: introduce mm_init()

  vmalloc: use kzalloc() instead of alloc_bootmem()

  slab: setup allocators earlier in the boot sequence

  bootmem: fix slab fallback on numa

  bootmem: use slab if bootmem is no longer available

Makes sense since it is very early in the boot I get the badness. Also, there is no mention of JFS in the above logs.

Cheers,
   Sean



