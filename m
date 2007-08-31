Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbXHaEDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbXHaEDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 00:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXHaED0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 00:03:26 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:52409 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXHaEDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 00:03:25 -0400
Date: Fri, 31 Aug 2007 13:35:28 +1000
To: Bret Towe <magnade@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-rc4 ppc build failure
Message-ID: <20070831033528.GN10345@bakeyournoodle.com>
References: <dda83e780708290941g1685879bned63a77d6b0fd242@mail.gmail.com> <dda83e780708301456y72bc4080qc994f4797a5fefd1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dda83e780708301456y72bc4080qc994f4797a5fefd1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 02:56:50PM -0700, Bret Towe wrote:
> On 8/29/07, Bret Towe <magnade@gmail.com> wrote:
> > while trying to build a fresh kernel for my mini after upgrading from gutsy
> > (and forgetting to save my .config) I hit the below build error
> > 2.6.23-rc3 I did work under feisty but that is with a different .config
> > so not sure if that makes any difference or not
> > I've not bisected cause it takes so long on this computer...
> > attached is the config I'm working off now

So how did you generate the new .config?  Did you start with a defconfig
of some sort and then alter to personal taste?

I ask because if we have other users our there that have working system
with BLK_DEV_IDE=m it'd be nice to have make oldconfig fix them.  If
it's just a matter of not letting people get into that state then
something like the patch below will probably help.

Ensure that BLK_DEV_IDE is built-in befoer allowing BLK_DEV_IDE_PMAC to
be selected.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

 drivers/ide/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index e049f65..e55be26 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -780,7 +780,7 @@ endif
 
 config BLK_DEV_IDE_PMAC
 	bool "Builtin PowerMac IDE support"
-	depends on PPC_PMAC && IDE=y
+	depends on PPC_PMAC && IDE=y && BLK_DEV_IDE=y
 	help
 	  This driver provides support for the built-in IDE controller on
 	  most of the recent Apple Power Macintoshes and PowerBooks.

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

