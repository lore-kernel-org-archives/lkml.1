Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbXJENYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbXJENYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXJENYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:24:24 -0400
Received: from sacred.ru ([62.205.161.221]:34592 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbXJENYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:24:23 -0400
Message-ID: <47063923.80607@openvz.org>
Date: Fri, 05 Oct 2007 17:16:19 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 2/3] Prepare pid_nr() etc functions to work with not-NULL
 pids
References: <4703A44F.9020402@openvz.org> <4703A53B.9090804@openvz.org> <20071003164258.GS19691@waste.org> <4704AA39.5030208@openvz.org> <20071004171311.GZ19691@waste.org>
In-Reply-To: <20071004171311.GZ19691@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 05 Oct 2007 17:18:52 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, Oct 04, 2007 at 12:54:17PM +0400, Pavel Emelyanov wrote:
>> Matt Mackall wrote:
>>> On Wed, Oct 03, 2007 at 06:20:43PM +0400, Pavel Emelyanov wrote:
>>>> Just make the __pid_nr() etc functions that expect the argument
>>>> to always be not NULL.
>>>>
>>>> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>>>>  static inline pid_t pid_nr(struct pid *pid)
>>>>  {
>>>>  	pid_t nr = 0;
>>>>  	if (pid)
>>>> -		nr = pid->numbers[0].nr;
>>>> +		nr = __pid_nr(pid);
>>>>  	return nr;
>>>>  }
>>> Is there a patch that removes these inlines? Otherwise this looks good
>>> to me.
>> Not yet. Some of are uninlined already, but others are not. I'd like 
>> to make some testing before uninline them.
> 
> I was asking about the whole function, actually, not the keyword. Is
> this function not equivalent to __pid_nr now?

Oh, I see. I haven't managed to check the whole kernel yet that all
the users of pid_xnr() calls pass not-null pointer there. This is 
in TODO list.

Thanks,
Pavel

