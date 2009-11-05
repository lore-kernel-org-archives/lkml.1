Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZKERcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZKERcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZKERcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:32:04 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33530 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751903AbZKERcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:32:03 -0500
X-Greylist: delayed 1129 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 12:32:03 EST
Message-ID: <4AF307A6.2010101@acm.org>
Date: Thu, 05 Nov 2009 10:13:10 -0700
From: Zan Lynx <zlynx@acm.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, mk@cm4all.com
Subject: Re: [PATCH] pipe: don't block after data has been written
References: <20091105153147.27473.19570.stgit@woodpecker.roonstrasse.net> <4AF2FD04.4030306@gmail.com> <20091105163603.GA4089@squirrel.roonstrasse.net> <4AF2FF5A.6050205@gmail.com>
In-Reply-To: <4AF2FF5A.6050205@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20091105/1N65tX-0001Pm-6S-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/09 9:37 AM, Eric Dumazet wrote:
> Max Kellermann a écrit :
>> On 2009/11/05 17:27, Eric Dumazet<eric.dumazet@gmail.com>  wrote:
>>> Your patch breaks many programs, that dont use poll()/select()
>>>
>>> char result[1000000];
>>> main()
>>> {
>>> 	computethings();
>>> 	write(1, buffer, 1000000);
>>> }
>>
>> Your code does not check the return value of write().  This is a bug.
>>
>
> Welcome to real world.

Yes in the real world there are bugs. The decision is to choose which 
bug you are going to expose. If it was my decision I would make the code 
work as documented, as Max wants to do.

I remember many years ago needing to fix some inetd-called server code 
that got unexpected partial writes on blocking sockets. It was either 
Solaris or HP/UX. So this is nothing new.

In fact I think that Linux will already do short writes if a signal is 
received without restart set for the handler. I found several bugs last 
year in glibc and libstdc++ fwrite and iostreams regarding that.
-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
