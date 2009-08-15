Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZHOWxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZHOWxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 18:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZHOWxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 18:53:35 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:52334 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZHOWxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 18:53:34 -0400
X-Greylist: delayed 1929 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Aug 2009 18:53:34 EDT
From: David Wagner <daw@cs.berkeley.edu>
Message-Id: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu>
Subject: Security: information leaks in /proc enable keystroke recovery
To: linux-kernel@vger.kernel.org
Date: Sat, 15 Aug 2009 15:21:27 -0700 (PDT)
Secret-Bounce-Tag: 9a029cbee41caf2ca77a77efa3c13981
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Usenix Security 2009, two researchers announced last week a new
security vulnerability in multi-user Linux systems.  They demonstrated
that one user can, in many cases, recover partial information about
the keystrokes that another user types into applications running on
that system.  For instance, they demonstrate how a malicious user can
recover partial information about SSH passwords typed by other users,
reducing the password search space by a factor of 250-2000x in
their experiments.  Thus, this could facilitate password recovery.

Question: Are there any plans to modify the Linux kernel to defend
against this kind of attack?

The paper is here:

http://www.usenix.org/events/sec09/tech/full_papers/zhang.pdf 

In a nutshell, they exploit the fact that many files in /proc are
world-readable yet contain sensitive information that can leak information
about inter-keystroke timings.  For instance, /proc/$PID/stat reveals the
ESP and EIP registers of the associated process, and is world-readable.
/proc/pid/status is also mentioned as revealing information that could
be exploited in these attacks.

Based on my understanding of their work, it sounds like some of
the information on those files should perhaps not be world-readable.
It's not clear to me that it's reasonable for the kernel to reveal ESP,
EIP, and other sensitive information about process behavior to everyone
on the same system.

Are folks already aware of these vulnerabilities?  Is there any work
underway to try to address the issues identified in the Usenix Security
paper?
