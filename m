Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbYHLOZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbYHLOZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYHLOZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:25:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38307 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752175AbYHLOZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:25:10 -0400
Date: Tue, 12 Aug 2008 10:25:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Possible false positive in checkpatch
Message-ID: <Pine.LNX.4.44L0.0808121017510.2509-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following appears to be a false positive in checkpatch:

ERROR: space prohibited after that '*' (ctx:BxW)
#163: FILE: drivers/usb/core/usb.c:304:
+#define usb_device_pm_ops      (* (struct pm_ops *) 0)
                                 ^

Certainly this is a rather uncommon code construction, but similar
ones might occur elsewhere.  To my eyes,

	(* (type *) ptr)

looks better than

	(*(type *) ptr)

or

	(*(type *)ptr)

or even

	(*(type*)ptr)

but of course this is a matter of opinion.  Is there any strong feeling 
about this in the kernel community?

Alan Stern

