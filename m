Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbXLMOFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbXLMOFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXLMOFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:05:36 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34820 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbXLMOFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:05:35 -0500
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 09:05:35 EST
Date: Thu, 13 Dec 2007 14:48:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: separate objdir Makefile regression in 2.6.24-rc*
Message-ID: <20071213134841.GA25103@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Dec 2007 13:42:43.0125 (UTC) FILETIME=[09549E50:01C83D8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-rc5 doesn't seem to create Makefiles in empty obj dirs anymore

With 2.6.24-rc5:

% mkdir obj-test
% cd obj-test/
% make -C ../linux O=$(pwd) allnoconfig >/dev/null
grep: /home/lsrc/quilt/obj-test/Makefile: No such file or directory
% make
make: *** No targets specified and no makefile found.  Stop.
% 

With 2.6.23 this worked:

% mkdir obj-test
% cd obj-test/
% make -C ../linux-2.6.23 O=$(pwd) allnoconfig >/dev/null
% make
make -C /home/lsrc/linux-2.6.23 O=/home/lsrc/obj-test
  GEN     /home/lsrc/obj-test/Makefile
scripts/kconfig/conf -s arch/x86_64/Kconfig
  Using /home/lsrc/linux-2.6.23 as source for kernel
...


-Andi
