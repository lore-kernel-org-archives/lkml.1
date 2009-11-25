Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbZKYAym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbZKYAym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbZKYAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:54:42 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54258 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542AbZKYAyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:54:41 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 24 Nov 2009 17:54:27 -0700
X-Google-Sender-Auth: bfdf8f17854ed779
Message-ID: <fa686aa40911241654w6ceb2c96nb3a6a57ac1b471f5@mail.gmail.com>
Subject: [RFC] two new linux-next trees (SPI and devicetree)
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michal Simek <michal.simek@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I've got two trees that I'd like to have some linux-next exposure, but
I don't want to step on any toes...

First one is a bunch of SPI patches.  I've made the offer to be SPI
co-maintainer, but I haven't received any feedback yet from either
akpm or dbrownell.  In the mean time, I still have a bunch of SPI
patches (properly signed off and everything) that should have
linux-next exposure before the merge window.  I've put them in the
tree shown in the request-pull output below.

David, akpm, please note:  I'm not intending to ask Linus to pull this
tree, but I do really need some feedback on what you want me to do.
The tree should be properly formed and signed off, so I can ask Linus
to pull from me directly if you wish.

The second one is a bunch of the device tree changes that I want to
give some linux-next exposure as soon as possible.  The tree is
properly formed, but I haven't collected a full set of acks from all
the relevant folks.  Once I get all the acks, I merge the commits into
the next-devicetree branch that you're already pulling.  Ben in
particular is very busy and hasn't had time to review.  They are in
this tree:

  git://git.secretlab.ca/git/linux-2.6 test-devicetree

So, here's the RFC.  I'd *like* to get them into linux-next before
benh gets time to ack them; but there is possibly a greater likelyhood
of breakage.  Can you add them to the end of the queue and just punt
it out if they cause grief?  Do you have any other suggestions?
Should I just put them into next-devicetree and fix it up as I get
acks?  (BTW, I have at least compile tested this tree on 32/64 bit
powerpc, 32/64 bit sparc and microblaze).

Thanks,
g.

The next-spi tree:

The following changes since commit b419148e567728f6af0c3b01965c1cc141e3e13a:
  Linus Torvalds (1):
        Linux 2.6.32-rc6

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Albrecht Dreß (5):
      mpc5200/gpt: tiny fix for gpt period limitation
      mpc52xx/wdt: OF property to enable the WDT on boot
      mpc52xx/wdt: merge WDT code into the GPT driver
      mpc52xx/wdt: remove obsolete old WDT implementation

Grant Likely (4):
      spi/mpc5200: Register SPI devices described in device tree
      powerpc/5200: Add mpc5200-spi (non-PSC) device driver
      powerpc/5200: add general purpose timer API for the MPC5200
      mmc: fix missing module license declaration in of_mmc_spi.c

John Bonesio (1):
      powerpc/5200: add LocalPlus bus FIFO device driver

John Linn (1):
      Xilinx: SPI: Fix bits_per_word for transfers

Luotao Fu (3):
      mpc52xx_spi: fix clearing status register
      mpc52xx_spi: add missing mode_bits definition
      mpc52xx_spi: add gpio chipselect

Richard Röjfors (4):
      xilinx_spi: Split into of driver and generic part.
      xilinx_spi: Switch to iomem functions and support little endian.
      xilinx_spi: add support for the DS570 IP.
      xilinx_spi: add a platform driver using the xilinx_spi common module.

Wolfram Sang (3):
      spi/mpc52xx-psc-spi: check for valid PSC
      spi/mpc52xx: replace printk with dev_err
      spi/mpc52xx-spi: minor cleanups

 Documentation/powerpc/dts-bindings/fsl/mpc5200.txt |   17 +-
 arch/powerpc/include/asm/mpc52xx.h                 |   47 ++
 arch/powerpc/kernel/io.c                           |    4 +-
 arch/powerpc/platforms/52xx/Kconfig                |    5 +
 arch/powerpc/platforms/52xx/Makefile               |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |  428 ++++++++++++++-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |  560 +++++++++++++++++++
 drivers/mmc/host/of_mmc_spi.c                      |    2 +
 drivers/spi/Kconfig                                |   28 +-
 drivers/spi/Makefile                               |    3 +
 drivers/spi/mpc52xx_psc_spi.c                      |   25 +-
 drivers/spi/mpc52xx_spi.c                          |  578 ++++++++++++++++++++
 drivers/spi/xilinx_spi.c                           |  358 ++++++-------
 drivers/spi/xilinx_spi.h                           |   32 ++
 drivers/spi/xilinx_spi_of.c                        |  134 +++++
 drivers/spi/xilinx_spi_pltfm.c                     |  102 ++++
 drivers/watchdog/Kconfig                           |    4 +-
 drivers/watchdog/Makefile                          |    1 -
 drivers/watchdog/mpc5200_wdt.c                     |  293 ----------
 include/linux/spi/xilinx_spi.h                     |   20 +
 20 files changed, 2136 insertions(+), 506 deletions(-)
 create mode 100644 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
 create mode 100644 drivers/spi/mpc52xx_spi.c
 create mode 100644 drivers/spi/xilinx_spi.h
 create mode 100644 drivers/spi/xilinx_spi_of.c
 create mode 100644 drivers/spi/xilinx_spi_pltfm.c
 delete mode 100644 drivers/watchdog/mpc5200_wdt.c
 create mode 100644 include/linux/spi/xilinx_spi.h


On Fri, Nov 20, 2009 at 11:01 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> Ping?  Any comments on this?
>
> If I don't hear anything, then I think I'm going to go ahead and push
> out a tree with all the SPI changes I've signed off on and ask sfr to
> add it to his list, just so that I'm sure that they get some
> linux-next exposure before Linus opens the merge window.  I won't
> necessarily ask LInus to pull it, I just want the testing.
>
> Cheers.
> g.
>
> On Fri, Nov 13, 2009 at 5:25 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> Hi David, Andrew.
>>
>> David, I know that you haven't had enough time lately to keep on top
>> of the pending SPI patches, so I was wondering if you would like some
>> help?  If you are interested, I'm willing to act as co-maintainer of
>> for the SPI subsystem.
>>
>> Here's what I'm thinking.  Right now all SPI patches are going through
>> the -mm tree and just adding to akpm's burden.  I'd be more than happy
>> to take over the task of actually collecting the acked patches into a
>> git tree, getting them some exposure on linux-next, and asking Linus
>> to pull it during the merge window.  If you ack them, then I'll merge
>> them.
>>
>> I'm also be willing to take responsibility for all powerpc-specific
>> SPI patches so that you don't need to look at them.
>>
>> How does this sound to you?
>>
>> Cheers,
>> g.
>>
>>  MAINTAINERS |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index a1a2ace..2b697cb 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4937,6 +4937,7 @@ F:        drivers/char/specialix*
>>
>>  SPI SUBSYSTEM
>>  M:     David Brownell <dbrownell@users.sourceforge.net>
>> +M:     Grant Likely <grant.likely@secretlab.ca>
>>  L:     spi-devel-general@lists.sourceforge.net
>>  S:     Maintained
>>  F:     Documentation/spi/
>>
>>
>
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
