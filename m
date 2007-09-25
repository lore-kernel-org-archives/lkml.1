Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXIYN7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXIYN7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 09:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXIYN64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 09:58:56 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34238 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXIYN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 09:58:55 -0400
Message-ID: <46F91417.9050600@davidnewall.com>
Date: Tue, 25 Sep 2007 23:28:47 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com>
In-Reply-To: <20070925114947.GA9721@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting David Newall (david@davidnewall.com):
>   
>> Serge E. Hallyn wrote:
>>     
>>> Quoting David Newall (david@davidnewall.com):
>>>   
>>>       
>>>> It might be tidy if pivot_root could be used (instead of a hack based on 
>>>> a chroot bug), but it'd still be unportable.
>>>>     
>>>>         
>>> It can.
>>>
>>> Please re-read my previous msg.
>>>       
>> I read it.  Currently pivot_root can't be used to affect a single process.  
>>     
>
> No.  If you unshare your mounts namespace immediately before pivot_root,
> then pivot_root will only affect that single process.
>   

Bugger.  You're right, I didn't read your previous message; I thought I 
had but I was wrong.

>>	unshare(CLONE_NEWNS);
>> 	chdir(new_dir);
>> 	pivot_root(new_dir, oldroot);


After further RTFMing, and assuming "any processes or threads which  
use  the  old  root directory" means what you imply, and surely it does, 
then I agree: pivot_root already does the job.  Does anybody still need 
to use a bug in chroot?
