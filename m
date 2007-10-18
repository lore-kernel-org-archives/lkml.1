Return-Path: <linux-kernel-owner+w=401wt.eu-S1763525AbXJRWEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763525AbXJRWEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXJRWDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:03:54 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44859 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135AbXJRWDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:03:53 -0400
Message-ID: <4717D7B6.40102@keyaccess.nl>
Date: Fri, 19 Oct 2007 00:01:26 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
References: <20071018202504.GA2854@dmt>	<4717C43D.6030204@keyaccess.nl>	<20071018165238.0537eaa6@bree.surriel.com>	<4717CAEC.50203@keyaccess.nl> <20071018171857.409255de@bree.surriel.com>
In-Reply-To: <20071018171857.409255de@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2007 11:18 PM, Rik van Riel wrote:

> On Thu, 18 Oct 2007 23:06:52 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> They don't -- that's why I asked if you need both scenario's active
>> at the same time. SIGDANGER would just be SIGPLEASEFREEALLYOUCAN with
>> the operator deciding through setting the level at which point
>> applications get it.
>>
>> Or put differently; what's the additional value of notifying an
>> application that the system is about to go balistic when you've
>> already asked it to free all it could earlier? SIGSEEDAMNITITOLDYOUSO?
> 
> The first threshold - "we are about to swap" - means the application
> frees memory that it can.  Eg. free()d memory that glibc has not yet
> given back to the kernel, or JVM running the garbage collector, or ...
> 
> The second threshold - "we are out of memory" - means that the first
> approach has failed and the system needs to do something else. On an
> embedded system, I would expect some application to exit or maybe
> restart itself.

That first threshold sounds fine yes. To me, the second mostly sounds like a 
job for SIGTERM though.

The OOM killer could after it selected the task for killing first try a TERM 
on it to give a chance to exit gracefully and only when that doesn't help 
make it eligible for killing on a second round through the badness calculation.

You could moreover _never_ make a task eligible for killing before it 
received a SIGTERM, thereby guaranteeing that everyone got the SIGTERM 
before killing anything, and it seems SIGTERM would be a more focussed 
version of SIGDANGER2 then.

Would at least forego any need for multiplexing the DANGER signal.

Rene.

