Return-Path: <linux-kernel-owner+w=401wt.eu-S1762656AbXJRVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762656AbXJRVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbXJRVJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:09:22 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46805 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbXJRVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:09:21 -0400
Message-ID: <4717CAEC.50203@keyaccess.nl>
Date: Thu, 18 Oct 2007 23:06:52 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
References: <20071018202504.GA2854@dmt>	<4717C43D.6030204@keyaccess.nl> <20071018165238.0537eaa6@bree.surriel.com>
In-Reply-To: <20071018165238.0537eaa6@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2007 10:52 PM, Rik van Riel wrote:
> On Thu, 18 Oct 2007 22:38:21 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 10/18/2007 10:25 PM, Marcelo Tosatti wrote:
>>
>>> AIX contains the SIGDANGER signal to notify applications to free up
>>> some unused cached memory:
>>>
>>> http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html
>>>
>>> There have been a few discussions on implementing such an idea on
>>> Linux, but nothing concrete has been achieved.
>>>
>>> On the kernel side Rik suggested two notification points: "about to
>>> swap" (for desktop scenarios) and "about to OOM" (for embedded-like
>>> scenarios).
>>>
>>> With that assumption in mind it would be necessary to either have
>>> two special devices for notification, or somehow indicate both
>>> events through the same file descriptor.
>>>
>>> Comments are more than welcome.
>> Given the desktop/embedded distinction you made, do you need both
>> scenarios active at the same time? If not, it seems something like a
>>
>> 	echo -n <level> >/proc/sys/vm/danger
>>
>> could do with just one sigdanger notification point? (with <level>
>> suitably defined as or in terms of the used threshold value).
> 
> If you do that, how are applications to know which of the two
> scenarios is happening when they get a signal?

They don't -- that's why I asked if you need both scenario's active at the 
same time. SIGDANGER would just be SIGPLEASEFREEALLYOUCAN with the operator 
deciding through setting the level at which point applications get it.

Or put differently; what's the additional value of notifying an application 
that the system is about to go balistic when you've already asked it to free
all it could earlier? SIGSEEDAMNITITOLDYOUSO?

Don't get me wrong; never saw this discussion earlier, may be sensible...

Rene.

