Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYEPDut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYEPDut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 23:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYEPDul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 23:50:41 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:34398 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754007AbYEPDuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 23:50:40 -0400
Message-ID: <482D0467.5080201@linux.vnet.ibm.com>
Date: Fri, 16 May 2008 09:19:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Seger <Mark.Seger@hp.com>
CC: Shailabh Nagar <nagar@watson.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>,
       Guillaume Thouvenin <guillaume.thouvenin@bull.net>,
       Jay Lan <jlan@engr.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: taskstats and /proc/.../io asymmetry?
References: <482AC60D.8020207@hp.com>
In-Reply-To: <482AC60D.8020207@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Seger wrote:
> If you look at /proc/pid/stat, you can get the total CPU consumed by a
> process.  If you look at /proc/pid/task/tid/stat you can get the cpu
> consumed by a thread and if the tid is that of the parent you only gets
> its consumption as opposed to all its children.
> 
> I was surprised to see that the way process I/O is reported doesn't
> follow this model.  There are no /prod/pid/task/tid/io entries but
> rather you need to look in /proc/tid/io.  While I view this as a minor
> inconvenience, I can certainly live with it.  However, /proc/pid/io does
> not show the aggregate I/O numbers for the whole process and that both
> surprises and disappoints.  This means if I have a process that starts a
> bunch of worker threads that do the real work and I want to find the top
> I/O consumers I can't simply walk the /proc/pid tree but rather have to
> look at all the threads of each process and add them up.
> 
> Or am I missing something?
> 

I looked through the code and your argument seems to be correct. The behaviour
is inconsistent w.r.t. other statistics like utime and stime. We currently
accumulate tgid information in signal_struct, we need to do something similar
for io as well. If nobody gets to it by the time I finish my backlog, I'll try
and get to it.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
