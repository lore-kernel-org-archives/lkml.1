Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbXGLFVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbXGLFVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 01:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbXGLFV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 01:21:28 -0400
Received: from 73.pool85-58-18.dynamic.orange.es ([85.58.18.73]:43200 "EHLO
	cafe.aluzina.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbXGLFV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 01:21:27 -0400
Message-ID: <4695BA52.7050709@aluzina.org>
Date: Thu, 12 Jul 2007 07:21:22 +0200
From: =?ISO-8859-1?Q?Zeus_G=F3mez_Marmolejo?= <zeus@aluzina.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: linux-kernel@vger.kernel.org
Subject: Re: New LSM security operation
References: <986851.77016.qm@web36607.mail.mud.yahoo.com>
In-Reply-To: <986851.77016.qm@web36607.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Lets run a thought experiment on this notion...
>
> Let's say that the file you want to hide is "/etc/dangerous".
> One of your fellows decides to create a file for other purposes
> and decides to call it "/etc/dangerous", having looked in /etc
> and seeing no file with that name. What should happen when he
> calls open("/etc/dangerous", O_CREAT) :
>
>    1. a second /etc/dangerous is created
>    2. the open fails, returning EEXISTS
>    3. the open succeeds, silently replacing the old file
>
> Option 1 results in two files with the same name. True,
> AppArmor can handle this, but I think everyone else
> is going to have issues with it. Option 2 defeats the idea
> of the file being hidden. Option 3 is just bad.
>   
I don't see much problem on this. For me, the correct response is that 
one that just forget the "hidden" attribute, in that case if the user 
have the permission of overwritting the file, then the open succeeds, 
replacing the old file. In the other case, if the "list permission" and 
the "create permission" are denied the open fails. We can discuss in 
this case if with an EEXISTS or EACCES... Nevertheless I think it's a 
good idea, the same happens when a file is "read protected" and "list 
protected", and the user want to open the file for reading it. It could 
be: EACCESS or even ENOENT...

Just think about how useful would be in the /proc directory. For now, 
applying the selinux policy and doing "ls /proc", it reports errors on 
directories not owned by you because it cann't getattr() on them, but 
you can even know how many processes are running and even their pids. 
You have to apply an extra patch like Grsecurity to don't list the pids 
that are not owned by you in /proc. With this hook, this won't be 
necessary, just with a correct policy it can be done.


Zeus.

