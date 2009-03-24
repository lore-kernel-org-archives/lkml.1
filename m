Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZCXNIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZCXNIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbZCXNIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:08:41 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:27222 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZCXNIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:08:40 -0400
Message-id: <49C8DB54.4010200@acm.org>
Date: Tue, 24 Mar 2009 08:08:36 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Greg KH <greg@kroah.com>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Openipmi-developer] Improving IPMI performance under load
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org>
 <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org>
 <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org>
 <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org>
 <49C8A823.6020809@fujitsu-siemens.com>
In-reply-to: <49C8A823.6020809@fujitsu-siemens.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Wilck wrote:
> Hi Corey,
>
> yesterday I posted some results about the IPMI performance under CPU 
> load, which can be up to 25 times slower than in an idle system. I think 
> it might be worthwhile to try to improve that behavior as well.
>   
Yes, that would be expected, as kipmid would never be scheduled in a 
busy system, and it would just be the timer driving things.

> I made a variation of my patch which introduces a second parameter 
> (kipmid_min_busy) that causes kipmid not to call schedule() for a 
> certain amount of time. Thus if there's IPMI traffic pending, kipmid 
> will busy-loop for kipmid_min_busy seconds, then starting to schedule() 
> in each loop as it does now, and finally go to sleep when 
> kipmid_max_busy is reached. At the same time, I changed the nice value 
> of kipmid from 19 to 0.
>   
I would guess that changing the nice value is the main thing that caused 
the difference.  The other changes probably didn't make as big a difference.

> With this patch and e.g. min_busy=100 and max_busy=200, there is no 
> noticeable difference any more between IPMI performance with and without 
> CPU load.
>
> The patch + results still need cleanup, therefore I am not sending it 
> right now. Just wanted to hear what you think.
>   
I'm ok with tuning like this, but most users are probably not going to 
want this type of behavior.

-corey
