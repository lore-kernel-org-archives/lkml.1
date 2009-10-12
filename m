Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZJLIm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZJLIm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 04:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZJLIm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 04:42:27 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:37613 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZJLImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 04:42:25 -0400
Message-ID: <4AD2EBC7.2020109@fr.ibm.com>
Date: Mon, 12 Oct 2009 10:41:43 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andrea@cpushare.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: pidns memory leak
References: <4AC5F198.2070407@fr.ibm.com> <20091006040526.GA22923@us.ibm.com>	<4ACAFD6A.3060008@fr.ibm.com>	<20091008030828.GA18973@us.ibm.com> <4ACD9ECC.90508@fr.ibm.com>	<20091009032928.GA2031@us.ibm.com> <4ACF381F.9050808@fr.ibm.com> <20091010013235.GA11904@us.ibm.com>
In-Reply-To: <20091010013235.GA11904@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> Ccing  Andrea's new email id:
>
> Daniel Lezcano [dlezcano@fr.ibm.com] wrote:
>   
>> Following your explanation I was able to reproduce a simple program  
>> added in attachment. But there is something I do not understand is why  
>> the leak does not appear if I do the 'lstat' (cf. test program) in the  
>> pid 2 context.
>>     
>
> Hmm, are you sure there is no leak with this test program ? If I put back
> the commit (7766755a2f249e7), I do see a leak in all three data structures
> (pid_2, proc_inode, pid_namespace).
>   

Let me clarify :)

The program leaks with the commit 7766755a2f249e7 and does not leak 
without this commit.
This is the expected behaviour and this simple program spots the problem.

I tried to modify the program and I moved the lstat to the process 2 in 
the child namespace. Conforming your analysis, I was expecting to see a 
leak too, but this one didn't occur. I was wondering why, maybe there is 
something I didn't understood in the analysis.

Thanks
  -- Daniel
