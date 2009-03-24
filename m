Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbZCXPvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbZCXPvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZCXPvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:51:41 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:58949 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbZCXPvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:51:40 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Mar 2009 11:51:40 EDT
Date: Tue, 24 Mar 2009 10:50:35 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Corey Minyard <minyard@acm.org>
Cc: Martin Wilck <martin.wilck@fujitsu-siemens.com>, Greg KH <greg@kroah.com>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Openipmi-developer] Improving IPMI performance under load
Message-ID: <20090324155035.GB16332@auslistsprd01.us.dell.com>
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org> <49C8A823.6020809@fujitsu-siemens.com> <49C8DB54.4010200@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C8DB54.4010200@acm.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 08:08:36AM -0500, Corey Minyard wrote:
> Martin Wilck wrote:
> >Hi Corey,
> >
> >yesterday I posted some results about the IPMI performance under CPU 
> >load, which can be up to 25 times slower than in an idle system. I think 
> >it might be worthwhile to try to improve that behavior as well.
> >  
> Yes, that would be expected, as kipmid would never be scheduled in a 
> busy system, and it would just be the timer driving things.
> 
> >I made a variation of my patch which introduces a second parameter 
> >(kipmid_min_busy) that causes kipmid not to call schedule() for a 
> >certain amount of time. Thus if there's IPMI traffic pending, kipmid 
> >will busy-loop for kipmid_min_busy seconds, then starting to schedule() 
> >in each loop as it does now, and finally go to sleep when 
> >kipmid_max_busy is reached. At the same time, I changed the nice value 
> >of kipmid from 19 to 0.
> >  
> I would guess that changing the nice value is the main thing that caused 
> the difference.  The other changes probably didn't make as big a difference.
> 
> >With this patch and e.g. min_busy=100 and max_busy=200, there is no 
> >noticeable difference any more between IPMI performance with and without 
> >CPU load.
> >
> >The patch + results still need cleanup, therefore I am not sending it 
> >right now. Just wanted to hear what you think.
> >  
> I'm ok with tuning like this, but most users are probably not going to 
> want this type of behavior.

I still get complaints from users who see their CPU utilization spike
attributed to kipmi0 when userspace throws a lot of requests down to
the controller.  I've seen them want to limit kipmi0 even further, not
speed it up.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
