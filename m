Return-Path: <linux-kernel-owner+w=401wt.eu-S1030800AbXCGOpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800AbXCGOpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030794AbXCGOpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:45:51 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60461 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800AbXCGOpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:45:50 -0500
Date: Wed, 7 Mar 2007 20:22:57 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 2/7] containers (V7): Cpusets hooked into containers
Message-ID: <20070307145257.GD32105@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.290909000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.290909000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:23AM -0800, menage@google.com wrote:
> -	mutex_lock(&callback_mutex);
> -	list_add(&cs->sibling, &cs->parent->children);
> +	cont->cpuset = cs;
> +	cs->container = cont;
>  	number_of_cpusets++;
> -	mutex_unlock(&callback_mutex);

What's the rule to read/write number_of_cpusets? The earlier cpuset code was
incrementing/decrementing under callback_mutex, but now we aren't. How safe is 
that? 

The earlier cpuset code also was reading number_of_cpusets w/o the
callback_mutex held (atleast in cpuset_zone_allowed_softwall). Is that safe?

-- 
Regards,
vatsa
