Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZJUSlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZJUSlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbZJUSlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:41:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:54476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbZJUSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:41:14 -0400
Date: Wed, 21 Oct 2009 11:42:10 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: discuss@LessWatts.org, lkml <linux-kernel@vger.kernel.org>,
       Corey Minyard <minyard@acm.org>,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH] ipmi: use round_jiffies on timers to reduce timer
 overhead/wakeups
Message-ID: <20091021114210.4d7e1ea9@linux.intel.com>
In-Reply-To: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 10:28:22 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use a round_jiffies() variant to reduce overhead of timer
> wakeups.  This causes the ipmi timers to occur at the same
> time as other timers (per CPU).
> 
> Typical powertop for /ipmi/ (2.6.31, before patch):
>   11.4% (247.4)            kipmi0 : __mod_timer (process_timeout) 
>    0.6% ( 13.1)       <interrupt> : ipmi_si 
>    0.5% ( 10.0)     <kernel core> : __mod_timer (ipmi_timeout) 
> 
> powertop for /ipmi/, 2.6.31, after patch:
>   10.8% (247.6)            kipmi0 : __mod_timer (process_timeout) 
>    0.3% (  6.9)       <interrupt> : ipmi_si 
>    0.0% (  1.0)     <kernel core> : __mod_timer (ipmi_timeout)

while it is nice that ipmi_si ande the timer wake up less now.... it's
still rather sad that the 247.6 from kipmi0 are still there..... those
are a much much bigger issue

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
