Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZIRVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZIRVKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZIRVKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:10:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754992AbZIRVKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:10:05 -0400
Date: Fri, 18 Sep 2009 14:09:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
In-Reply-To: <m14or0vul4.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.01.0909181407370.4950@localhost.localdomain>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org> <20090917185306.GA28635@elte.hu> <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com> <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
 <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com> <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain> <1253238637.4071.10.camel@yio.site> <m14or0vul4.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Sep 2009, Eric W. Biederman wrote:
> 
> As a special case you can implement this much
> more simply in devtmpfs_mount just do:
> 
> int devtmpfs_mount(const char *mountpoint)
> {
>         sys_mount("none", "dev", "devtmpfs", MS_SILENT, NULL);
> 	sys_chmod("dev/console", 0666);
> 	sys_chmod("dev/tty", 0666);
> 	sys_chmod("dev/null", 0666);
> 	sys_chmod("dev/zero", 0666);
> }

Yeah, I think that's the way to go.

But add some error checking for sys_mount(), so that the code in question 
would _never_ try to do a chmod() on some unrelated /dev/ entries. 

(Ok, so the mount isn't supposed to fail, but still - conceptually that's 
a really important error to check for)

		Linus
