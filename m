Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZLMDZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZLMDZP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 22:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbZLMDZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 22:25:14 -0500
Received: from lists.laptop.org ([18.85.2.145]:41618 "HELO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756000AbZLMDZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 22:25:13 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Dec 2009 22:25:13 EST
From: Michael Stone <michael@laptop.org>
Cc: Michael Stone <michael@laptop.org>
Subject: Network isolation with RLIMIT_NETWORK, cont'd.
Date: Sat, 12 Dec 2009 22:19:37 -0500
Message-Id: <1260674379-4262-1-git-send-email-michael@laptop.org>
X-Mailer: git-send-email 1.5.6.5
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear lkml,

A few months ago [1], I asked for feedback on a new network isolation primitive
named "RLIMIT_NETWORK" designed for use with Unix sandboxing utilities like
Rainbow, Plash, and friends [2]. Thank you to all those CC'ed for your helpful
early remarks.

Here is an updated patchset with responses to the following criticisms:

  1. ptrace() 
     
     It was pointed out by Alan Cox, Andi Kleen, and others that processes
     which dropped their RLIMIT_NETWORK rlimit were still able to directly
     perform networking through a ptrace()'d victim.

     The new patchset adds an access check to __ptrace_may_access() to prevent
     this behavior.

  2. unshare(CLONE_NEWNET)

     It was pointed out by James Morris that network namespaces could be used
     to implement behavior similar to the behavior this patchset is designed to
     implement. To address this criticism, I added support for network
     namespaces to my sandboxing utility (Rainbow).

     Unfortunately, I have discovered that network namespaces in their current
     form are not appropriate for my use cases because they prevent the
     namespace'd apps from connecting to the X server, even over plain old
     AF_UNIX sockets.

     The RLIMIT_NETWORK facility I propose contains a specific exception for
     AF_UNIX filesystem sockets since those sockets are already bound by
     regular Unix discretionary access control.

  3. style

     I have made the patches more consistent with the kernel style
     guidelines.

Further suggestions?

Michael

[1] http://kerneltrap.org/mailarchive/linux-netdev/2009/1/7/4624864
[2] http://sandboxing.org
