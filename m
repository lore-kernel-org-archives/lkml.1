Return-Path: <linux-kernel-owner+w=401wt.eu-S1750872AbXCHKcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750872AbXCHKcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbXCHKcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:32:19 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38095 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXCHKcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:32:18 -0500
Date: Thu, 8 Mar 2007 16:08:08 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, pj@sgi.com, ebiederm@xmission.com,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       serue@us.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070308103808.GH6504@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070307122117.GB2336@in.ibm.com> <6599ad830703071250p6c92a357g51391a23ee3d78d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703071250p6c92a357g51391a23ee3d78d8@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 12:50:03PM -0800, Paul Menage wrote:
> The callback mutex (which is what container_lock() actually locks) is
> also used to synchronize fork/exit against subsystem additions, in the
> event that some subsystem has registered fork or exit callbacks. We
> could probably have a separate subsystem_mutex for that instead.

Why can't manage_mutex itself be used there (to serialize fork/exit callbacks
against modification to hierarchy)?

> Apart from that, yes, it may well be possible to move callback lock
> entirely inside cpusets.

Yes, that way only the hierarchy hosting cpusets takes the hit of
double-locking. cpuset_subsys->create/destroy can take this additional lock 
inside cpuset.c.

-- 
Regards,
vatsa
