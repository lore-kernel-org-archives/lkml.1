Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXCGMOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXCGMOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 07:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXCGMOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 07:14:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34151 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXCGMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 07:14:18 -0500
Date: Wed, 7 Mar 2007 17:51:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070307122117.GB2336@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.130746000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:22AM -0800, menage@google.com wrote:
> +/**
> + * container_lock - lock out any changes to container structures
> + *
> + * The out of memory (oom) code needs to mutex_lock containers
> + * from being changed while it scans the tasklist looking for a
> + * task in an overlapping container.

Which specific portion of oom code cares abt container structure being
intact? 

If I understand correctly, only cpuset requires this double locking.
More specifically, cpusets cares about walking cpuset->parent list
safely with callback_mutex held correct?

If that is the case, I think we can push container_lock entirely inside 
cpuset.c and not have others exposed to this double-lock complexity.
This is possible because cpuset.c (build on top of containers) still has
cpuset->parent and walking cpuset->parent list safely can be made
possible with a second lock which is local to only cpuset.c.

-- 
Regards,
vatsa
