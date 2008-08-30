Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYH3JTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYH3JTM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYH3JS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:18:57 -0400
Received: from main.gmane.org ([80.91.229.2]:47440 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYH3JS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:18:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthias Urlichs <matthias@urlichs.de>
Subject: [Regression] sshd hangs on close
Date: Sat, 30 Aug 2008 09:18:47 +0000 (UTC)
Message-ID: <g9b39n$4et$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: smurf.noris.de
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"top" sees multiple instances of:

 6008 root      20 3184 D    0   0:00.06 flush_cpu sshd: root@pts/13            

This is 2.6.27rc5, preemption and tickless turned on, on a 4-CPU machine.
(OK, two hyperthreaded ones :-P) strace() shows that this happens on the
last close of its /dev/ptmx file descriptor, which hangs.

I'll do a bisect early next week unless somebody else identifies a likely
suspect.

-- 
Matthias Urlichs

