Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbZDOWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbZDOWcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZDOWce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:32:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbZDOWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:32:33 -0400
Date: Wed, 15 Apr 2009 15:27:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: norsk5@yahoo.com, michael@ellerman.id.au,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 2/3] EDAC: Add edac_device_alloc_index()
Message-Id: <20090415152730.79d8053c.akpm@linux-foundation.org>
In-Reply-To: <1239602716-18352-3-git-send-email-qingtao.cao@windriver.com>
References: <1239602716-18352-1-git-send-email-qingtao.cao@windriver.com>
	<1239602716-18352-2-git-send-email-qingtao.cao@windriver.com>
	<1239602716-18352-3-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 14:05:15 +0800
Harry Ciao <qingtao.cao@windriver.com> wrote:

> Add edac_device_alloc_index(), because for MAPLE platform there may
> exist several EDAC driver modules that could make use of
> edac_device_ctl_info structure at the same time. The index allocation
> for these structures should be taken care of by EDAC core.
> 

From: Andrew Morton <akpm@linux-foundation.org>

keep things neat.  Also avoids having global identifier device_index
shadowed by local identifier device_index.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Harry Ciao <qingtao.cao@windriver.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/edac/amd8111_edac.c~edac-add-edac_device_alloc_index-cleanup drivers/edac/amd8111_edac.c
diff -puN drivers/edac/edac_core.h~edac-add-edac_device_alloc_index-cleanup drivers/edac/edac_core.h
diff -puN drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~edac-add-edac_device_alloc_index-cleanup
+++ a/drivers/edac/edac_device.c
@@ -37,7 +37,6 @@
  */
 static DEFINE_MUTEX(device_ctls_mutex);
 static LIST_HEAD(edac_device_list);
-static atomic_t device_indexes = ATOMIC_INIT(0);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
@@ -499,6 +498,8 @@ void edac_device_reset_delay_period(stru
  */
 int edac_device_alloc_index(void)
 {
+	static atomic_t device_indexes = ATOMIC_INIT(0);
+
 	return atomic_inc_return(&device_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_device_alloc_index);
_

