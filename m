Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYE0OOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYE0OOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYE0OOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:14:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:18422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbYE0OOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:14:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=j0xn0xW6IOov8M1AMxyphZ0qAD7btIc+m57W17tltmH6Q0+tTFZYqkKOovAC+dBOrKDdRyftK4nOJsg0DvsmURm0r6NrVsbZxriu3+xR+ZTicntx0kA9HxXj3GCoP/4iFns8JpTgGm3p4ZeV0yIL2kSfF3tZMKFaGdhkqQHE4PE=
Message-ID: <483C1731.2060408@gmail.com>
Date: Tue, 27 May 2008 16:14:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Noel (Sourceforge)" <noelb@users.sourceforge.net>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org
Subject: Re: PROBLEM: Serial error
References: <1211836442.5745.1.camel@roswell.ausics.net>	 <483B3B7C.1000306@gmail.com>  <483C0CDD.2000409@gmail.com> <1211895684.1698.10.camel@roswell.ausics.net>
In-Reply-To: <1211895684.1698.10.camel@roswell.ausics.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noel (Sourceforge) napsal(a):
> On Tue, 2008-05-27 at 23:30, Jiri Slaby wrote:
>> Jiri Slaby napsal(a):
>>> On 05/26/2008 11:14 PM, Noel (Sourceforge) wrote:
>>>> serial comms error with smsclient  >2.6.25 , worked fine up until and
>>>> including 2.6.24.7
>> There is >2.6.25. It means post 2.6.26-rc1 inclusively?
>>
> 
> Yes, it broke as of 2.6.25 , I also obtained  .1 through .4 and still
> broken in each, I have not tried  2.6.26-rc1 as I assume the code
> breaking this is still in the tree
> 
> 
> 
>> If you double checked this, trying to CC Alan if he doesn't have a clue.
>> For reference:
>> http://lkml.org/lkml/2008/5/26/260
> 
> Yes, checked.

Ah, this one goes through platform driver (why do you load istallion and 
stallion drivers?).

8250.c driver changes:
Alan Cox (3):
       serial: Coding style
       serial8250: coding style
       8250: enable rate reporting via termios

Will Newton (1):
       8250.c: support specifying DW APB UARTs in device platform_data

Nothing seems intrusive, but whatever changes in the rest of the serial 
might have caused it. Could you bisect it? I think it would be fast.

git-bisect v2.6.25 v2.6.24 -- drivers/char/ drivers/serial/
