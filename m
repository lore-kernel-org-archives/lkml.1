Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbXBNO7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbXBNO7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333AbXBNO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:59:33 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33549 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbXBNO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:59:32 -0500
Date: Wed, 14 Feb 2007 20:29:14 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, dipankar@in.ibm.com,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       oleg@tv-sign.ru, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070214145914.GA1566@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144305.GB19789@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 08:13:05PM +0530, Gautham R Shenoy wrote:
> This patch reverts all the recent workqueue hacks added to make it 
> hotplug safe. 

Oleg,
	This patch probably needs review for any races we may have
missed to account for.  Also we have considered only workqueue.c present
in 2.6.20-rc6-mm3, which means some recent patches in mm tree which are
yet to be published arent accounted for.

Also I expect almost all worker threads to be frozen "for hotplug". The
only exception I have found so far is kthread workqueue, which needs to
remain unfrozen "for cpu hotplug" because kthread_create (in
CPU_UP_PREPARE and stop_machine) relies on its services (while everyone else 
is frozen). 

-- 
Regards,
vatsa
