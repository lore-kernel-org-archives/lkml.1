Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZKYK24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZKYK24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZKYK2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:28:55 -0500
Received: from verein.lst.de ([213.95.11.210]:49351 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZKYK2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:28:55 -0500
Date: Wed, 25 Nov 2009 11:28:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Message-ID: <20091125102857.GA28310@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently upgraded my Thinkpad T500 from Linux 2.6.31 to Linux
2.6.32-rc (first -rc7 but I've also tried with -rc6 and -rc8) and when
putting load on it, e.g. by building a kernel tree.  It shuts down soon
with the

	Critical temperature reached (%ld C), shutting down.\n"

printk from drivers/thermal/thermal_sys.c, where the temperature is
usually 100C or slightly above.  The system is a Lenovo Thinkpad T500
with a Intel Core 2 Dueo T9600 running a 32 bit kernel.

I've done some attempts at bisecting it, but for most of the 2.6.32-rc
series the system crashes during boot in ACPI code with a backtrace
longer than the screen can display.
