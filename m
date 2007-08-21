Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbXHUDof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbXHUDof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 23:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXHUDoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 23:44:25 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42649 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbXHUDoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 23:44:25 -0400
Message-ID: <46CA5F8D.20104@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2007 09:14:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jonathan Lim <jlim@sgi.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Send exit code through for taskstats.ac_exitcode
References: <200708210222.l7L2MFcJ377626@sabah.engr.sgi.com>
In-Reply-To: <200708210222.l7L2MFcJ377626@sabah.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Lim wrote:
> taskstats.ac_exitcode is assigned to task_struct.exit_code in bacct_add_tsk()
> through the following kernel function calls: 
> 
>   do_exit()
>     taskstats_exit_send()
>       fill_pid()
>         bacct_add_tsk()
> 
> The problem is that in do_exit(), task_struct.exit_code is set to 'code' 
> only after taskstats_exit_send() has been called.  So we need to send 'code'
> through to bacct_add_tsk().
> 

Hi, Jonathan,

The patches look like a step in the right direction, I would suggest an alternate
implementation

Why can't we assign tsk->exit_code to code earlier? Can we not move up the assignment
to before taskstats_exit()? Wouldn't that be much simpler?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
