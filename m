Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYJGAmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYJGAmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYJGAlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:41:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:46507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbYJGAlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:41:09 -0400
Date: Mon, 6 Oct 2008 17:37:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andy Gospodarek <andy@greyhouse.net>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 04/71] ixgbe: initialize interrupt throttle rate
Message-ID: <20081007003733.GE3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ixgbe-initialize-interrupt-throttle-rate.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andy Gospodarek <andy@greyhouse.net>

commit 15e79f24b60c4b0bf8019423bda4e03a576b02f2 upstream

This commit dropped the setting of the default interrupt throttle rate.

commit 021230d40ae0e6508d6c717b6e0d6d81cd77ac25
Author: Ayyappan Veeraiyan <ayyappan.veeraiyan@intel.com>
Date:   Mon Mar 3 15:03:45 2008 -0800

    ixgbe: Introduce MSI-X queue vector code

The following patch adds it back.  Without this the default value of 0
causes the performance of this card to be awful.  Restoring these to the
default values yields much better performance.

This regression has been around since 2.6.25.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -2258,6 +2258,12 @@ static int __devinit ixgbe_set_interrupt
 	int vector, v_budget;
 
 	/*
+	 * Set the default interrupt throttle rate.
+	 */
+	adapter->rx_eitr = (1000000 / IXGBE_DEFAULT_ITR_RX_USECS);
+	adapter->tx_eitr = (1000000 / IXGBE_DEFAULT_ITR_TX_USECS);
+
+	/*
 	 * It's easy to be greedy for MSI-X vectors, but it really
 	 * doesn't do us much good if we have a lot more vectors
 	 * than CPU's.  So let's be conservative and only ask for

-- 
