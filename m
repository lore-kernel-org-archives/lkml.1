Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXD1TFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXD1TFp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXD1TFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:05:44 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:32892 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754006AbXD1TFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:05:13 -0400
Date: Sat, 28 Apr 2007 11:28:06 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Oliver Neukum <oliver@neukum.org>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280858.26615.oliver@neukum.org>
Message-ID: <Pine.LNX.4.63.0704281118550.11638@qynat.qvtvafvgr.pbz>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <1177718250.4737.222.camel@nigel.suspend2.net> 
 <Pine.LNX.4.63.0704271638150.11000@qynat.qvtvafvgr.pbz>
 <200704280858.26615.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-667593041-1177784886=:11638"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-667593041-1177784886=:11638
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Sat, 28 Apr 2007, Oliver Neukum wrote:

> Am Samstag, 28. April 2007 01:50 schrieb David Lang:
>> 3. make mounted filesystems read-only (possibly with snapshot/checkpoint)
>> 4. unpause
>> 5. save image (with full userspace available, including network)
>> 6. shutdown system (throw away all userspace memory, no need to do graceful
>>     shutdown or nice kill signals, revert filesystem to snapshot/checkpoint if
>>     needed)
>
> And then you'll have people wonder why the server which sent out all
> those files has no log entries. You'd have to selectively unfreeze user
> space, which is a cure worse than the desease.
>
> Simply throwing away user space work is a bug. And no, you cannot say that
> it'll be redone away, as you are throwing away accepted input, too.

when you are doing a suspend-to-disk I disagree with you. whoever is doing the 
suspend knows what is going on, and they can decide what needs to be done.

the only case where you have 'unexpected' work being thrown away is if you are 
suspending a network server, and the process of suspending it is going to cut 
all the network connections anyway so it's not a seamless process. In this case 
it's fair to let the sysadmin choose between loosing some logs or doing some 
other step to prevent this from happening (which could be to shutdown the 
network service, or load a iptables rule to block the service)

however, most of the uses of suspend-to-disk are going to be single-user 
machines and in that case telling the user that anything that they do after 
issuing the suspend is going to be lost is a perfectly sane thing to do.

and for that matter, if the snapshot is cheap enough, some people may choose to 
cron the snapshot portion of a suspend-to-disk evvery few min as a safety net 
for something going wrong. In this case they really do want all of userspace to 
keep working after the snapshot.

David Lang
--8323328-667593041-1177784886=:11638--
