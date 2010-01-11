Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592Ab0AKFQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab0AKFQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 00:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372Ab0AKFQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 00:16:07 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44003 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0AKFQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 00:16:04 -0500
Date: Mon, 11 Jan 2010 05:15:54 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [git pull] agp-fixes
Message-ID: <alpine.DEB.2.00.1001110514490.19527@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-530079517-1263186954=:19527"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-530079517-1263186954=:19527
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'agp-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-fixes

One fix for a real oops on IA64 AGP system + 2 minor fixes.

Dave.

 drivers/char/agp/backend.c |   13 +++++++++----
 drivers/char/agp/hp-agp.c  |    6 ++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

commit 3d4a7882b11299104a0e74425dece2e26ac98024
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 7 12:58:56 2010 -0700

    agp/hp: fail gracefully if we don't find an IOC
    
    Bail out if we don't find an enclosing IOC.  Previously, if we didn't
    find one, we tried to set things up using garbage for the SBA/IOC register
    address, which causes a crash.
    
    This crash only happens if firmware supplies a defective ACPI namespace, so
    it doesn't fix any problems in the field.
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 67fe63b0715ccfaefa0af8a6e705c5470ee5cada
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Jan 7 12:58:51 2010 -0700

    agp/hp: fixup hp agp after ACPI changes
    
    Commit 15b8dd53f5ffa changed the string in info->hardware_id from a static
    array to a pointer and added a length field.  But instead of changing
    "sizeof(array)" to "length", we changed it to "sizeof(length)" (== 4),
    which corrupts the string we're trying to null-terminate.
    
    We no longer even need to null-terminate the string, but we *do* need to
    check whether we found a HID.  If there's no HID, we used to have an empty
    array, but now we have a null pointer.
    
    The combination of these defects causes this oops:
    
      Unable to handle kernel NULL pointer dereference (address 0000000000000003)
      modprobe[895]: Oops 8804682956800 [1]
      ip is at zx1_gart_probe+0xd0/0xcc0 [hp_agp]
    
      http://marc.info/?l=linux-ia64&m=126264484923647&w=2
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Reported-by: Émeric Maschino <emeric.maschino@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

commit 3f50b0222e4c6ac59a5c4819f8be0fa500970381
Author: Kevin Winchester <kjwinchester@gmail.com>
Date:   Tue Nov 17 14:38:45 2009 -0800

    agp: correct missing cleanup on error in agp_add_bridge
    
    While investigating a kmemleak detected leak, I encountered the
    agp_add_bridge function.  It appears to be responsible for freeing
    the agp_bridge_data in the case of a failure, but it is only doing
    so for some errors.
    
    Fix it to always free the bridge data if a failure condition is
    encountered.
    
    Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-530079517-1263186954=:19527--
