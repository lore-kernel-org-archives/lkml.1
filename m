Return-Path: <linux-kernel-owner+w=401wt.eu-S1760995AbYHOTcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995AbYHOTcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYHOTb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:31:58 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:43911 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094AbYHOTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:31:57 -0400
Date: Sat, 16 Aug 2008 01:01:32 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: menage@google.com, pj@sgi.com
Cc: danms@us.ibm.com, Balbir Singh <balbir@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
Subject: Default values for cpuset.mems, cpus for children created
Message-ID: <20080815193132.GE11844@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While playing around with libcgroup, one of the isses hit was that
attaching a task failed. Looking deeper into it, cpusets had been
mounted along with other subsystems. And since we did not care about
cpusets, we did not set cpus and mems there.

Now an application programmer does not really care where and how
subsystems are mounted (or at least that is what libcgroup aims to
achieve :-) ). And such a scenario when the cpuset has not been handled
is going to lead to failures which a user is not expecting.

To work around this, I am making a change which will just set the values
which the parent group has for unfilled values, but I can already see
cpuset breaking that assumption as well. (for example exclusive
cpusets).

I was wondering, why can we not have some sane default values set for
cpus and mems when a group is created. (That will also avoid a lot of
heartbreak for me as well :-) ) (Or if you have some sane solution that
has not hit me yet, i am all ears)

Thanks,
-- 
regards,
Dhaval
