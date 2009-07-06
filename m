Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZGFGRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZGFGRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZGFGRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:17:44 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:40285 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZGFGRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:17:43 -0400
Message-ID: <4A51966C.3000102@free.fr>
Date: Mon, 06 Jul 2009 08:15:08 +0200
From: Albert ARIBAUD <albert.aribaud@free.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
References: <20090703015554.GB5880@cr0.nay.redhat.com>	 <20090703051917.GE5880@cr0.nay.redhat.com>	 <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>	 <20090703071504.GG5880@cr0.nay.redhat.com>	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>	 <20090703081655.GH5880@cr0.nay.redhat.com>	 <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>	 <20090703094229.GI5880@cr0.nay.redhat.com>	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>	 <4A4DDD54.9030206@free.fr> <412e6f7f0907051812q4b3d7bcfkff73c75da14a9cf4@mail.gmail.com>
In-Reply-To: <412e6f7f0907051812q4b3d7bcfkff73c75da14a9cf4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao a écrit :
> On Fri, Jul 3, 2009 at 6:28 PM, Albert ARIBAUD<albert.aribaud@free.fr> wrote:
>> Changli Gao a écrit :
>>
>>> Yea, in many cases, max fd number must be enlarged. More fds means
>>> more memory. Although memory is cheaper today, we have to do our best
>>> to save money.
>> Sorry for interrupting, but I don't see how pipe could return a single fd,
>> considering there are two (partly) independent ends, each being read (resp.
>> written) in their own time, and an fd has only one "current read/write
>> position" IIUC.
>>
>> If the proposal is to have two independent positions (one for reads and one
>> for writes) for a single fd, then I am not sure the gain in the number of
>> fds used is worth the loss in the increased size of the fd structure.
>>
>> Am I missing something?
 >
> pipe doesn't support llseek.

I wasn't thinking of actively seeking a file position, but simply that reads 
and writes were independent (and both variable) in size, thus even without 
(l)seeking, each endpoint has an independent read (resp. write) position to 
track what's been read from (resp.written into) it at any time, and such a 
position is, IIUC, single for a given fd, making a fd (a struct file) 
insufficient for representing a pipe.

Amicalement,
-- 
Albert.
