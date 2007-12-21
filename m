Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbXLUQHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbXLUQHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXLUQHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:07:36 -0500
Received: from mail3b.westend.com ([212.117.79.78]:45224 "EHLO
	mail3b1.westend.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756593AbXLUQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:07:35 -0500
X-Greylist: delayed 1726 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 11:07:35 EST
Date: Fri, 21 Dec 2007 16:38:45 +0100
From: Christian Hammers <ch@lathspell.de>
To: <linux-kernel@vger.kernel.org>
Subject: Debugging process hanging in D status and not responding to SIGKILL
Message-ID: <20071221163845.6fa3f2a9@sys-251.netcologne.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Occasionally all my apache2 processes hang in "D" process status where they are
no longer responsible to SIGKILL which makes the server almost un-rebootable.
The processes usually vanish after about 15-30min.

I know that this usually means "I/O wait" somewhere deep inside a kernel 
function where signals are not handled.

But using "strace -p <pid>" I can only see that the last called function is
flock() (according to /proc/<pid>/fd somebody produced a deadlock when using 
PHP sessions). But flock() normally terminates on SIGTERM and SIGKILL.

Could it be a problem with my SCSI driver who's involed in the flock process?
The problem usually occurs on two other webserver at the same time, one using
the same hardware and one being a Dell 6850 with Dell PERC RAID, though.

How can I get further debugging information that could give me a hint?

The system:
	Kernel: 2.6.22-3-amd64 (modified by Debian distribution)
	CPU: Quad Dualcore Intel(R) Xeon(R) E5310  @ 1.60GHz, 8GB RAM
	M/B: Transtec Server with Intel 5000 Series Chipset
	SCSI: 3ware Inc 9550SX SATA-RAID with firmware FE9X 3.08.00.016

bye,

-christian-
