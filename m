Return-Path: <linux-kernel-owner+w=401wt.eu-S965499AbXCGN7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbXCGN7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965503AbXCGN7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:59:12 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36507 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965499AbXCGN7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:59:11 -0500
Date: Wed, 7 Mar 2007 19:36:04 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, pj@sgi.com, ebiederm@xmission.com,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       serue@us.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070307140604.GB32105@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070307122117.GB2336@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307122117.GB2336@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 05:51:17PM +0530, Srivatsa Vaddagiri wrote:
> If that is the case, I think we can push container_lock entirely inside 
> cpuset.c and not have others exposed to this double-lock complexity.
> This is possible because cpuset.c (build on top of containers) still has
> cpuset->parent and walking cpuset->parent list safely can be made
> possible with a second lock which is local to only cpuset.c.

Hope I am not shooting in the dark here!

If we can indeed avoid container_lock in generic code, it will simplify
code like attach_task (for ex: post_attach/attach can be clubbed into one 
single callback).

-- 
Regards,
vatsa
