Return-Path: <linux-kernel-owner+w=401wt.eu-S1758716AbZCTPi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716AbZCTPi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 11:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZCTPiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 11:38:51 -0400
Received: from gw.goop.org ([64.81.55.164]:53068 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZCTPiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 11:38:50 -0400
Message-ID: <49C3B886.8080408@goop.org>
Date: Fri, 20 Mar 2009 08:38:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>, Avi Kivity <avi@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Question about x86/mm/gup.c's use of disabled interrupts
References: <49C148AF.5050601@goop.org> <200903191232.05459.nickpiggin@yahoo.com.au> <49C2818B.9060201@goop.org> <20090320044029.GD6807@linux.vnet.ibm.com>
In-Reply-To: <20090320044029.GD6807@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>> Ah, interesting.  So disabling interrupts prevents the RCU free from 
>> happening, and non-atomic pte fetching is a non-issue.  So it doesn't 
>> address the PAE side of the problem.
>>     
>
> This would be rcu_sched, correct?
>   

I guess?  Whatever it is that ends up calling all the rcu callbacks 
after the idle.  A cpu with disabled interrupts can't go through idle, 
right?  Or is there an explicit way to hold off rcu?

    J
