Return-Path: <linux-kernel-owner+w=401wt.eu-S1031032AbXEAI3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031032AbXEAI3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 04:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031136AbXEAI3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 04:29:32 -0400
Received: from mail.queued.net ([207.210.101.209]:1047 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031032AbXEAI3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 04:29:31 -0400
Message-ID: <4636FA67.70407@debian.org>
Date: Tue, 01 May 2007 04:29:27 -0400
From: Andres Salomon <dilinger@debian.org>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, dann frazier <dannf@hp.com>,
       linux-kernel@vger.kernel.org, support@moxa.com.tw
Subject: Re: old buffer overflow in moxa driver
References: <20070430224829.GI31283@krebs.dannf> <20070501000455.2173b1e2@the-village.bc.nu> <4636F337.3060702@gmail.com>
In-Reply-To: <4636F337.3060702@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Alan Cox napsal(a):
>>>   I noticed that the moxa input checking security bug described by
>>> CVE-2005-0504 appears to remain unfixed upstream.
>>>  
>>> The issue is described here:
>>>   http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2005-0504
>>>
>>> Debian has been shipping the following patch from Andres Salomon. I
>>> tried contacting the listed maintainer a few months ago but received
>>> no response.
>>
>>        case MOXA_LOAD_BIOS:
>>         case MOXA_FIND_BOARD:
>>         case MOXA_LOAD_C320B:
>>         case MOXA_LOAD_CODE:
>>                 if (!capable(CAP_SYS_RAWIO))
>>                         return -EPERM;
>>                 break;
>>
>> At the point you abuse these calls you can already just load arbitary
>> data from userspace anyway.
> 
> The problem is that we BUG_ON, when len < 0 in copy_from_user which is unlikely
> something we want to cause?
> 
> regards,


Right; the lack of input checking is most definitely a bug.  It's no
longer a security issue, as a CAP_SYS_RAWIO check was added at some
point to the code path, but it's still a bug.
