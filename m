Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203Ab0A2AZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0A2AZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999Ab0A2AZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:25:51 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:37634 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752583Ab0A2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:25:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mp5MnA3zW6bm66gnOhonKpDY11usGj5KfWiGIy79mCSFO1Nau24CXa2iNgTr9dKTcHGZdHU0dNrFdAfG71O2ntqS3iyVnEUgWqL0Z64IGSwZPm5TRtQ4NffMTdoPnPv3;
Date: Thu, 28 Jan 2010 16:25:44 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100128162544.3ec49105@jbarnes-piketon>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 61c39bb354a1f791ba6f562b766a72e508a036ee:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git390.marist.edu/pub/scm/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just a couple this time, the most controversial being the removal of
intel_bus.c.  We tried, but it's looking like a long idea in the log
term.  The machine it was intended to serve has working _CRS support
now, so they can boot with pci=use_crs.  For 2.6.34 we'll try using
more _CRS data by default, I'm hoping if we can get it right that it'll
fix a few other resource issues (though we have yet to address the
issue that broke things last time: huge numbers of _CRS resources on
some machines; should be easy to fix though).

Andrew Patterson (1):
      PCI: fix nested spinlock hang in aer_inject

Jeff Garrett (1):
      x86/PCI: remove IOH range fetching

 arch/x86/pci/Makefile             |    2 +-
 arch/x86/pci/intel_bus.c          |   94 -------------------------------------
 drivers/pci/pcie/aer/aer_inject.c |   12 ++--
 3 files changed, 7 insertions(+), 101 deletions(-)
 delete mode 100644 arch/x86/pci/intel_bus.c

-- 
Jesse Barnes, Intel Open Source Technology Center
