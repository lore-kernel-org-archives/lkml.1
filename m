Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYHTTb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYHTTb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYHTTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:31:10 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:34275 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYHTTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:31:08 -0400
Date: Wed, 20 Aug 2008 16:29:25 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: linux-kernel@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, mingo@elte.hu
Subject: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080820162925.75a5e064@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi there,

 Users of different Linux distros (includes Ubuntu, Mandriva, ArchLinux and
possibly Fedora) are reporting that kernel 2.6.26.2 is OOPSing in the
Virtual Box emulator[1].

 It is not clear if this is a kernel or Virtual Box bug, but as the kernel
is also OOPsing in QEMU (although with different behaivor) I have decided
to post my debug results here in case someone is interested in debugging
the kernel part further.

 I have done a bisection by hand among kernel versions and found that
the commit which triggers the oops in _Virtual Box_ was introduced in
2.6.26-rc1 and the problem also happens with latest Linus tree.

 By using git bisect I found that the commit is this:

"""
commit e587cadd8f47e202a30712e2906a65a0606d5865
Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date:   Thu Mar 6 08:48:49 2008 -0500

    x86: enhance DEBUG_RODATA support - alternatives

[...]

"""

 By reverting this commit I don't get the OOPS anymore. I have
tested with 2.6.26-rc1 and latest Linus tree (2.6.27-rc3).

 What puzzles me though is that a similar problem happens with
QEMU, but it also OOPSes with kernels before 2.6.26-rc1,
reverting the patch above makes no difference and it works with
current Linus tree.

 Does this look like a kernel bug?

 All my tests have been done with vanilla kernels, but I have
built .iso installation images with them and I'm not sure of
what the build script does.

[1] http://en.wikipedia.org/wiki/Virtual_box

 Thanks for reading this.

-- 
Luiz Fernando N. Capitulino
