Return-Path: <linux-kernel-owner+w=401wt.eu-S1758066AbZAPIHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066AbZAPIHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZAPIHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:07:06 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:56913 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZAPIHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:07:05 -0500
Subject: regression: a0d4922 causes PCI host constroller problems
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Jan 2009 09:05:25 +0100
Message-Id: <1232093125.2876.1.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a0d4922 ("USB: fix up suspend and resume for PCI host
controllers") causes a lot of these two lines to be logged:

uhci_hcd 0000:00:1d.2: host system error, PCI problems?
uhci_hcd 0000:00:1d.2: host controller process error, something bad
happened!

Normally they appear on resume after suspend to disk, but sometimes I'm
not even sure I had to suspend to disk to see them. Also, it seems like
they don't trigger if X has not been started, or at least they are much
less likely to.

Reverting the patch restores normal operation.

No USB devices were attached BTW.


Simon Holm Thøgersen

