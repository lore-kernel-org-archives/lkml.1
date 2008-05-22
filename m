Return-Path: <linux-kernel-owner+w=401wt.eu-S934543AbYEVMQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543AbYEVMQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbYEVMQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:16:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:3372 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYEVMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f7szVFq1jifka5L2ryh1gmxRRkU5mtT+eyEV38mQV9/J4+kpGoVvwpNepY3VlFWTUy5XV2/bus81X3bXbWtp32o7uDmM3/bkw5+G1tAe+zlW/FI4r3R1cAIW0mEOexCfce1F7FPEYRGZCBo/4w8+gKA46cEL1OTqXZ45/vO8VG0=
Message-ID: <863e9df20805220516x7e6cd4ecvc4e88e2d4ec62ed@mail.gmail.com>
Date: Thu, 22 May 2008 17:46:19 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Srinivasa DS" <srinivasa@in.ibm.com>
Subject: Re: [RFC] [PATCH] To improve kretprobe scalability
Cc: "Jim Keniston" <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ananth Mavinakayanahalli" <ananth@in.ibm.com>,
       "Masami Hiramatsu" <mhiramat@redhat.com>,
       "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>
In-Reply-To: <483531DA.8030203@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805210632.17655.srinivasa@in.ibm.com>
	 <863e9df20805220007r36089c93p6f2a787818aa150c@mail.gmail.com>
	 <483531DA.8030203@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/08, Srinivasa DS <srinivasa@in.ibm.com> wrote:
>  There were ideas of storing kretprobe instances in task_struct to get rid
> of locking, but that would require extending task_struct

Wouldn't chaining of return instances in task_struct only increase its
size by sizeof(struct list_head) bytes?

> and catching each task exit, destroying its kretprobe instances.

Which is kind of stil done by (...or at least we have a precendent of
this issue's awareness) kprobe_flush_task().

> This makes code more invasive.

Ok.

>  But in this implementation (global hash table, hashed by task), we
>  lock only the current task's hash bucket and hence we have fairly low
> contention.

I may be underestimating the complexity of having returns instances
associated with current task_struct, but anything else seems counter
intuitive. There might be more possibilites to exploit the fact that
functions instances are per-task.

A step in the right direction nevertheless :-)

>  Thanks
>   Srinivasa DS
--
Regards,
Abhishek Sagar
