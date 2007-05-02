Return-Path: <linux-kernel-owner+w=401wt.eu-S2993185AbXEBWFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993185AbXEBWFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993186AbXEBWFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:05:13 -0400
Received: from eth8932.sa.adsl.internode.on.net ([150.101.246.227]:46036 "EHLO
	aix.gdt.id.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993185AbXEBWFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:05:11 -0400
X-Greylist: delayed 3624 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 18:05:11 EDT
Message-ID: <4638FCEA.4010806@gdt.id.au>
Date: Thu, 03 May 2007 06:34:42 +0930
From: Glen Turner <gdt@gdt.id.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Detecting process death for anycast named process monitoring
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi folks,

Anycast services are a nice way of robustly offering DNS and other
services.  We create an interface which reflects the availability
of the service and advertise that into the network using a OSPF
router like Quagga.

For more detail see
http://www.aarnet.edu.au/~gdt/presentations/2006-07-18-linuxsa-anycast/
which is a summary of work which was presented at linux.conf.au.

The question is, how can a process with no relationship to another
process detect that process unexpectedly dying?  If named goes
away to a better place, we want to shut down the interface
which causes Quagga to inject the anycast route.

We don't want to be the parent of the running process, because that
doesn't add robustness. If the parent process dies, then the service
dies, and the interface still stays up.

We don't want to poll, because that isn't pretty and the polling
interval needs to be very short on a big ISP's DNS servers.

I have tried using the various notify functions against /proc, but
they don't work for that filesystem. I have tried using notify
against a UNIX domain socket, but notify doesn't work for
that either.

Suggestions, or a patch to support notify for /proc or to push
process death notifications into DBUS or whatever, are welcome.

Thank you, Glen
