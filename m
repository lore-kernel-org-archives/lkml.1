Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab0CCICh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:02:37 -0500
Received: from isilmar.linta.de ([213.133.102.198]:49097 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753867Ab0CCICe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:02:34 -0500
Date: Wed, 3 Mar 2010 08:59:44 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [git pull] more PCMCIA updates for 2.6.34 (including ioctl
 deprecation)
Message-ID: <20100303075944.GA23354@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

a few more PCMCIA patches for 2.6.34 are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

The diffstat and list of changes is below, the individual diffs are sent
(at least) to the linux-pcmcia list. This patchset includes one
controversial patch, titled:

      pcmcia: disable pcmcia ioctl for !ARM, prepare for removal

Most notably, Russell King objects to it for reasons spelled out e.g. at
http://lkml.org/lkml/2008/2/27/291 . I suspect the platform he is referring
to actually does work with the PCMCIA ioctl disabled; Russell's offer from
2008 to

   "spend some time [...] working out what it requires from the ioctl
   interface - maybe we can have a cut-down ioctl interface that bolts straight
   on as an "add on" to the new controls without being too invasive, while
   still allowing its PCMCIA bits to work."
   (http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005450.html)

hasn't lead to any result so far; he has indicated he won't get to spending
time on it soon. Because of the lack of progress in this regard, and for the
other reasons spelled out in the patch, I picked up Alan's suggestion to

   "[...] push[ing] it. If it matters someone will then fix up the problem
   platform. If it isn't pushed then it lets one obscure platform stall
   progress for everyone else."
  (http://lists.infradead.org/pipermail/linux-pcmcia/2008-April/005453.html)

Please pull from that location insofar as you agree to continue with the
deprecation of the PCMCIA ioctl. Otherwise, I can prepare a branch
_without_ this controversial patch to pull from.

Thanks,
        Dominik


Dominik Brodowski (2):
      pcmcia: CodingStyle fixes
      pcmcia: disable pcmcia ioctl for !ARM, prepare for removal

Komuro (1):
      pcmcia: remove irq_list parameter from pd6729

Manuel Lauss (1):
      pcmcia: alchemy: fixup wrong comments

Michal Pecio (1):
      yenta_socket: ENE CB712 CardBus bridge needs special treatment with Echo Audio Indigo soundcards

 Documentation/feature-removal-schedule.txt |   12 +-
 drivers/pcmcia/Kconfig                     |   14 +-
 drivers/pcmcia/cardbus.c                   |    2 +-
 drivers/pcmcia/cistpl.c                    | 1908 ++++++++++++++--------------
 drivers/pcmcia/db1xxx_ss.c                 |   19 +-
 drivers/pcmcia/pd6729.c                    |   18 +-
 drivers/pcmcia/rsrc_mgr.c                  |    3 +-
 drivers/pcmcia/xxs1500_ss.c                |   16 +-
 drivers/pcmcia/yenta_socket.c              |    8 +-
 9 files changed, 973 insertions(+), 1027 deletions(-)
