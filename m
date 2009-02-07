Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZBGSEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZBGSEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 13:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZBGSDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 13:03:54 -0500
Received: from outbound-mail-111.bluehost.com ([69.89.18.7]:60751 "HELO
	outbound-mail-111.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753008AbZBGSDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 13:03:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Zf/2LjTdlK1MrmLwu/ARvkvt0NAgMEGMRwYdnsf9CWdEmOAq0apm1Nq9ph245hnfUhgP4wpzpuWzNp/yjdWWolcqCrnQ1yAS4uPdGH2PtS6qHZGLQ0/lsLE6jGH810Cz;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: 2.6.29-rc3: tg3 dead after resume
Date: Sat, 7 Feb 2009 10:03:49 -0800
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Parag Warudkar <parag.lkml@gmail.com>,
       Matt Carlson <mcarlson@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0901281858380.5048@parag-desktop> <200902040141.15920.rjw@sisk.pl> <alpine.LFD.2.00.0902061858120.3048@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902061858120.3048@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071003.50525.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 7:00 pm Linus Torvalds wrote:
> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> > On Wednesday 04 February 2009, Parag Warudkar wrote:
> > > On Tue, 3 Feb 2009, Rafael J. Wysocki wrote:
> > > > Can you also test this one instead and tell me if it still works?
> > >
> > > Removing Linus' patch and applying the below one works as well.
> >
> > Great, thanks for testing.
> >
> > I'm going to push this one to Jesse.
>
> Jesse, should I take this directly (and presumably the related series by
> Rafael)?
>
> I was going to release -rc4 this weekend (it's already more than a week -
> I'm bad), and I'd hate for pci-e bridges to not resume correctly. So I'd
> either like a pull request from you with the pending suspend fixes, or
> I'll just apply the patch(es) directly.

Ok, you can just pull from me then.  /me uses request-pull wow that's easy.


The following changes since commit eda58a85ec3fc05855a26654d97a2b53f0e715b9: 
  Linus Torvalds (1):                                                        
        Merge branch 'for-linus' of git://git.kernel.org/.../cooloney/blackfin-2.6                                                                              

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Alex Chiang (1):
      PCI: properly clean up ASPM link state on device remove

Rafael J. Wysocki (7):
      PCI PM: Fix handling of devices without drivers
      PCI PM: Check if the state has been saved before trying to restore it
      PCI PM: Fix saving of device state in pci_legacy_suspend
      PCI: PCIe portdrv: Simplify suspend and resume
      PCI PM: Do not disable and enable bridges during suspend-resume
      PCI PM: Read power state from device after trying to change it on resume
      PCI PM: make the PM core more careful with drivers using the new PM framework

Timothy S. Nelson (1):
      PCI: return error on failure to read PCI ROMs

 Documentation/filesystems/sysfs-pci.txt |   13 +++-
 arch/ia64/sn/kernel/io_acpi_init.c      |    2 +-
 arch/ia64/sn/kernel/io_init.c           |    2 +-
 drivers/pci/pci-driver.c                |  164 ++++++++++++++++++++-----------
 drivers/pci/pci-sysfs.c                 |    4 +-
 drivers/pci/pci.c                       |    4 +-
 drivers/pci/pcie/aspm.c                 |    4 +-
 drivers/pci/pcie/portdrv_pci.c          |   16 +---
 drivers/pci/rom.c                       |    8 +-
 include/linux/pci.h                     |    2 +-
 10 files changed, 132 insertions(+), 87 deletions(-)

-- 
Jesse Barnes, Intel Open Source Technology Center
