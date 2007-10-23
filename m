Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXJWUA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXJWUA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXJWUAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:00:15 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:64910 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXJWUAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:00:13 -0400
Subject: [RFC PATCH 0/2] use virtual time for CFS on s390
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefksy <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 22:02:08 +0200
Message-Id: <1193169728.5922.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

an outcome from the previous discussion about a virtual sched_clock() on s390
was that scheduler_tick() should also be called based on virtual time.
The second patch changes the scheduler_tick() call to only happen after a tick
passed for the virtual cpu.

The patches cause nothing obvious to break, numbers from top look sane but 
I've seen something strange...

For a simple make -j6 workload top reports processes very often to be in 
state <defunct>. Thats' not terribly wrong since this can happens also 
without the patches but I wonder if this indicates that the scheduler behaves
badly and does less often schedule the parent processes that gathers the 
waiting zombie processes?

Are there any indicators in the sched_debug output that I could look for?

Jan

