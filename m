Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXBSLec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXBSLec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932120AbXBSLeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:34:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbXBSLea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:34:30 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070218214407.GA4229@tv-sign.ru> 
References: <20070218214407.GA4229@tv-sign.ru> 
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jun Nakajima <jun.nakajima@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cpufreq_ondemand.c: don't use _WORK_NAR 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 19 Feb 2007 11:33:47 +0000
Message-ID: <8561.1171884827@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Looks like dbs_timer() is very careful wrt per_cpu(cpu_dbs_info),
> and it doesn't need the help of WORK_STRUCT_NOAUTOREL.

Actually, I think my problem with this was dbs_info->sample_type, but reading
it again, I'm not sure that it's actually a problem as the work function will
probably not ever be executing on two or more CPUs simultaneously because of
the deferral time involved.

So, your patch is probably fair enough.  Certainly, deletion isn't a problem.

Acked-By: David Howells <dhowells@redhat.com>
