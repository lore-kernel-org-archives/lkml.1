Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYLOXPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYLOXPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 18:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYLOXPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 18:15:09 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55989 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbYLOXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 18:15:08 -0500
Date: Mon, 15 Dec 2008 23:15:02 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: driver probe error reporting
Message-ID: <20081215231502.GC12431@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This runs on from the discussion in [1] on how drivers (especially
one using a variant of the device driver framework) report errors
on probe. There are two main classes of errors, the type which happen
at probe time (device not responding, not enough memory, etc) and
errors that are due to configuration such as missing device configuration
data.

It has been suggested that using dev_err() to report any configuration
data error is a bloat of code as a properly debugged kernel should never
find itself in this state.

Unfortunatley the only diagnostic dev_xxx() macro is dev_dbg() which is
only available if the the driver code itself defines DEBUG. I would think
it would be better to have a macro that can be turned on/off by a kernel
configuration for when debugging which turns on the messages that are
important to developers creating new machine/arch support but disabled
for shipping kernels.

Basically, what are people's thoughts on a "Verbose probe error"
configuration option in the "Kernel hacking" submenu with its own
dev_probe_err() or similar macro?


[1] http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/ce6260537381dd94/7ed3f699db907357?show_docid=7ed3f699db907357

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
