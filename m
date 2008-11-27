Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbYK0XXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbYK0XXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 18:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYK0XXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 18:23:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYK0XXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 18:23:40 -0500
Date: Thu, 27 Nov 2008 23:23:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 14/32] ixgbe section fixes (against netdev)
Message-ID: <20081127232335.GF28946@ZenIV.linux.org.uk>
References: <E1L3wOM-0006Ti-Jt@ZenIV.linux.org.uk> <9929d2390811221143n66f3f09bu3801919a54263589@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9929d2390811221143n66f3f09bu3801919a54263589@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 11:43:17AM -0800, Jeff Kirsher wrote:
> On Sat, Nov 22, 2008 at 9:35 AM, Al Viro <viro@ftp.linux.org.uk> wrote:
> >
> > ixgbe_init_interrupt_scheme() is called from ixgbe_resume().  Build that
> > with CONFIG_PM and without CONFIG_HOTPLUG and you've got a problem.
> > Several helpers called by it also are misannotated __devinit.
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  drivers/net/ixgbe/ixgbe_main.c |    9 ++++-----
> >  1 files changed, 4 insertions(+), 5 deletions(-)
> >
> 
> Adding Netdev...
> 
> Patch does not apply to latest net-next-2.6 tree because half of the
> requested changes are already applied to the driver in an earlier
> commit.
> 
> Please re-test with
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
> if possible.

ixgbe_init_interrupt_scheme() is called from ixgbe_resume().  Build that
with CONFIG_PM and without CONFIG_HOTPLUG and you've got a problem.
Several helpers called by it also are misannotated __devinit.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ixgbe/ixgbe_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index 7e1cc6e..f7228ad 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -2460,7 +2460,7 @@ static void ixgbe_acquire_msix_vectors(struct ixgbe_adapter *adapter,
  * Once we know the feature-set enabled for the device, we'll cache
  * the register offset the descriptor ring is assigned to.
  **/
-static void __devinit ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
+static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
 {
 	int feature_mask = 0, rss_i;
 	int i, txr_idx, rxr_idx;
@@ -2565,8 +2565,7 @@ err_tx_ring_allocation:
  * Attempt to configure the interrupts using the best available
  * capabilities of the hardware and the kernel.
  **/
-static int __devinit ixgbe_set_interrupt_capability(struct ixgbe_adapter
-                                                    *adapter)
+static int ixgbe_set_interrupt_capability(struct ixgbe_adapter *adapter)
 {
 	int err = 0;
 	int vector, v_budget;
-- 
1.5.6.5

