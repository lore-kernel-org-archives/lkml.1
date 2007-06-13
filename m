Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXFMNm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXFMNm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 09:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbXFMNmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 09:42:20 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:34240 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752903AbXFMNmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 09:42:19 -0400
Message-ID: <466FF154.7030905@aitel.hist.no>
Date: Wed, 13 Jun 2007 15:29:56 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
CC: Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random> <466FB6E8.8020606@free.fr>
In-Reply-To: <466FB6E8.8020606@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:
> Andrea Arcangeli wrote:
>
>> On Wed, Jun 13, 2007 at 10:49:29AM +0200, John Sigler wrote:
>>
>>> Question 2: how can I tell which process or kernel thread was 
>>> hogging most of the RAM when the oom-killer kicked in?
>>
>> Theoretically the one that was killed first but not for sure in
>> current mainline hence see below.
>
> If I read the logs correctly, oom-killer is "invoked" three times 
> before it effectively kills a process. Then oom-killer kills myapp, 
> syslogd, and boa, in that order. Why didn't oom-killer kill anything 
> the first three times?
My guess:
Something needs memory but finds there is none to be had
oom-killer is invoked and targets myapp.
myapp takes some time to die. Particularly, the memory it uses
isn't freed up instantly. In the meantime something else
needs memory and find none. (Another packet received?)
The oom-killer is invoked again, this time it targets syslogd.

And so on.  The kernel do many things in parallel, running out
of memory in a multitasking system therefore is a complicated business.
Especially when process killing takes some time.

Note that you can turn off memory overcommit, your leaky app
should then get a memory allocation error instead of
triggering the oom-killer.

Helge Hafting

