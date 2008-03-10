Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbYCJOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbYCJOu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYCJOuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:50:15 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:57001 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYCJOuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:50:14 -0400
Message-ID: <47D54A8B.2020303@mandic.com.br>
Date: Mon, 10 Mar 2008 11:49:47 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alan-jenkins@tuffmail.co.uk, tglx@linutronix.de, devzero@web.de,
       mingo@elte.hu
Subject: Re: Kernel Linux 2.6.23.16 hangs when run updatedb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'd: Thomas Gleixner
cc'd: Ingo Molnar
About hrtimer comment by Alan Jenkins



Alan Jenkins wrote:
> Renato S. Yamane wrote:
>> devzero@web.de wrote:
>>> Renato S. Yamane wrote:
>>>> when cron start updatedb daemon, my machine hangs. None key work, so I
>>>> need reset (press power button to restart).
>>>>
>>>> The only way to get log is runing updatedb from terminal (CTRL + ALT +
>>>> F1) and take a picture from screen:
>>>>
>>>> Up screen:
>>>> <http://img137.imageshack.us/img137/7128/01pg1.jpg>
>>>>
>>>> Down screen:
>>>> <http://img100.imageshack.us/img100/1456/02kx1.jpg>
>>>>
>>>> Call trace detail:
>>>> <http://img100.imageshack.us/img100/8233/calltracedetailsj7.jpg>
>>>
>>>
>>> looks like reiserfs issue.
>>> maybe corrupt filesystem and improper handling of the reiserfs-driver?
>>>
>>> could you try some "find /" ?
>>
>>
>> "find /" don't hangs my machine.
>> The problem is only with updatedb.
>>
>> How can I fix this? Is safe run reiserfsck?
>
> 
> I think he's wrong.
> 
> Looking at the call trace, the BUG happens during an interrupt.  It
> could be a coincidence that the interrupt happened during this
> particular system call.
> 
> It looks like a timer callback has been corrupted / set to an invalid
> value.  The BUG is due to accessing the invalid address 61060fe0
> within enqueue_hrtimer, and the EIP (instruction pointer) is also
> equal to 61060fe0.  This would be consistent with the source code of
> enqueue_hrtimer.  It's not an obvious reiserfs issue.
> 
> I don't know how to find out where this corruption is happening, but
> it's worth asking the hrtimers people.

