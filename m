Return-Path: <linux-kernel-owner+w=401wt.eu-S933393AbYEVInI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbYEVInI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYEVImx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:42:53 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:42963 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYEVImv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:42:51 -0400
Message-ID: <483531DA.8030203@in.ibm.com>
Date: Thu, 22 May 2008 14:12:02 +0530
From: Srinivasa DS <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: Jim Keniston <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH] To improve kretprobe scalability
References: <200805210632.17655.srinivasa@in.ibm.com> <863e9df20805220007r36089c93p6f2a787818aa150c@mail.gmail.com>
In-Reply-To: <863e9df20805220007r36089c93p6f2a787818aa150c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhishek Sagar wrote:
> On 5/21/08, Srinivasa D S <srinivasa@in.ibm.com> wrote:
>>  Solution:
>>    1) Instead of having one global lock to protect kretprobe instances
>>  present in kretprobe object and kretprobe hash table. We will have two locks,
>>  one lock for protecting kretprobe hash table and another lock for kretporbe
>>  object.
> 
> Is it possible to get rid of the kretprobe hash table itself and lose
> the kretprobe_lock? It seems like it is just doing a pid-to-instance
> mapping. These return instances could be queued in the "current"
> task_struct in a LIFO manner. Mutation to this per-task list can be
> done with local irqs off...
> 

There were ideas of storing kretprobe instances in task_struct to get 
rid of locking, but that would require extending task_struct and 
catching each task exit, destroying its kretprobe instances. This makes 
code more invasive.
But in this implementation (global hash table, hashed by task), we
lock only the current task's hash bucket and hence we have fairly low 
contention.

Thanks
  Srinivasa DS
