Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZGNPGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZGNPGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZGNPGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:06:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57873 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZGNPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:06:15 -0400
Message-ID: <4A5C9EE4.4040101@monstr.eu>
Date: Tue, 14 Jul 2009 17:06:12 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: Re: access_ok macor
References: <4A5C8068.6020203@monstr.eu> <200907141521.47719.arnd@arndb.de> <4A5C8BF2.8020505@monstr.eu> <200907141645.48833.arnd@arndb.de>
In-Reply-To: <200907141645.48833.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 14 July 2009, Michal Simek wrote:
>> Arnd Bergmann wrote:
>> Look at
>> http://developer.petalogix.com/git/gitweb.cgi?p=ltp-microblaze.git;a=commitdiff;h=45f4cd783ce8b94f1267bb87c0c46e8536f62eca
>>
>> There are three affected tests and my quick fixes which I am trying to solve now.
>>
> 
> ok, I see.
>  
>> int move_addr_to_user(struct sockaddr *kaddr, int klen, void __user *uaddr,
>> 		      int __user *ulen)
>> {
>> 	int err;
>> 	int len;
>>
>> 	err = get_user(len, ulen);
>> 	if (err)
>> 		return err;
>>
> 
> So the code looks something like
> 
>                         "1:     lw      %1, %2, r0;                     \
>                                 addk    %0, r0, r0;                     \
>                         2:                                              \
>                         .section .fixup,\"ax\";                         \
>                         3:      brid    2b;                             \
>                                 addik   %0, r0, %3;                     \
>                         .previous;                                      \
>                         .section ,\"a\";                      		\
>                         .word   1b,3b;                                  \
>                         .previous;"                                     \

yes,

> 
> Not much that can go wrong there. First of all, I'd check that the
> code actually looks the same in the binary. I assume that the 'addik'
> gets executed when the brid branches, right?

yes, it should bri-d meant branch with delay slot and addik is in delay.

> 
> I would guess that some of the logic in do_page_fault might be
> broken and does not actually call the fixup.

ok.

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
