Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZCKK7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZCKK7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 06:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbZCKK66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 06:58:58 -0400
Received: from main.gmane.org ([80.91.229.2]:39916 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbZCKK65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 06:58:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Dmitriy V'jukov" <dvyukov@gmail.com>
Subject: RCU: Number of grace-periods
Date: Wed, 11 Mar 2009 10:58:41 +0000 (UTC)
Message-ID: <loom.20090311T104939-544@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 209.3.12.206 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.7) Gecko/2009021910 Firefox/3.0.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the article "The design of preemptible read-copy-update":
http://lwn.net/Articles/253651

Paul McKenney explains why number of grace periods before executing callbacks is
set to 2:
#define GP_STAGES 2

There are following statements in the reasoning:
"Note that because rcu_read_lock() does not contain any memory barriers, the
contents of the critical section might be executed early by the CPU"
and:
"However, because rcu_read_unlock() contains no memory barriers, the contents of
the corresponding RCU read-side critical section (possibly including a reference
to the item deleted by CPU 0) can be executed late by CPU 1"

But on some architectures (IA-32, Intel 64, SPARC TSO) acquire and release
fences are implied with every load/store (read - costless), so isn't it possible
to reduce the number of required grace periods before executing callbacks on
these architectures?
I.e. something like:
#ifdef ACQUIRE_RELEASE_FENCES_ARE_IMPLIED_ON_ARCH // defined for x86 etc
#define GP_STAGES 1
#else
#define GP_STAGES 2
#endif
Have someone considered such variant? Is it worth doing?
Thank you.

--
Best regards,
Dmitriy V'jukov

