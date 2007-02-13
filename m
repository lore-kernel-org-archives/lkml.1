Return-Path: <linux-kernel-owner+w=401wt.eu-S1751016AbXBMFtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016AbXBMFtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbXBMFtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:49:16 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38453 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXBMFtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:49:15 -0500
Date: Tue, 13 Feb 2007 11:18:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070213054857.GD22982@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070212123309.GA7526@in.ibm.com> <6599ad830702121126o35fb0cb6x696a4a56079bce40@mail.gmail.com> <6599ad830702121146y41c8856cm4a85943aa950771f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830702121146y41c8856cm4a85943aa950771f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 11:46:20AM -0800, Paul Menage wrote:
> On further reflection, this probably would be safe after all. Since we
> don't call put_container_group() in attach_task() until after
> synchronize_rcu() completes, that implies that a container_group_get()
> from the RCU section would have already completed. So we should be
> fine.

Right.

Which make me wonder why we need task_lock() at all ..I can understand
the need for a lock like that if we are reading/updating multiple words
in task_struct under the lock. In this case, it is used to read/write
just one pointer, isnt it? I think it can be eliminated all-together
with the use of RCU.


-- 
Regards,
vatsa
