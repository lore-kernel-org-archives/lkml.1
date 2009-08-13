Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZHMQUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZHMQUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 12:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZHMQUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 12:20:15 -0400
Received: from xenotime.net ([72.52.64.118]:41659 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752018AbZHMQUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 12:20:14 -0400
Message-ID: <4A843D66.1060407@xenotime.net>
Date: Thu, 13 Aug 2009 09:20:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Johannes Weiner <hannes@cmpxchg.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, stern@rowland.harvard.edu,
       akpm@linux-foundation.org, apw@canonical.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
References: <13a78aa7-dd27-49d9-8164-d6e802bd4796@default>	 <20090813145106.GA25333@cmpxchg.org> <1250175853.3901.34.camel@mulgrave.site>
In-Reply-To: <1250175853.3901.34.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2009-08-13 at 16:51 +0200, Johannes Weiner wrote:
>> Okay, I came up with a syntax to allow continued lines in short
>> descriptions and parameter descriptons.
>>
>> I can successfully parse
>>
>> ---
>> /**
>>  *	get_tty_driver		-	find device of a tty
>>  *					...and everything
> 
> I'm not so keen on the ... syntax ... suggestions below

I like this even less than James does.

>>  *	@device: device identifier
>>  *		... to identify the device with
>>  *		... that is to be matched
>>  *	@index: returns the index of the tty
>>  *		... for your personal pleasure
>>  *
>>  *	This routine returns a tty driver structure, given a device number
>>  *	and also passes back the index number.
>>  *
>>  *	Locking: caller must hold tty_mutex
>>  */
>> ---
>>
>> to
>>
>> ---
>> Name:
>>
>> get_tty_driver - find device of a tty and everything
>>
>> Synopsis:
>>
>> struct tty_driver * get_tty_driver (dev_t device,
>>                                     int * index);
>>
>> Arguments:
>>
>> device
>>         device identifier to identify the device with that is to be matched
>> index
>>         returns the index of the tty for your personal pleasure
>>
>> Description:
>>
>> This routine returns a tty driver structure, given a device number
>> and also passes back the index number.
>> Locking:
>>
>> caller must hold tty_mutex
>> ---
>>
>> Unfortunately, perl requires me to ignore my pathetic rest of taste,
>> so it may well be horribly ugly without me noticing ;) Would the
>> following work for you?  I will happily incorporate improvements.
>>
>> 	Hannes
>>
>> ---
>>
>> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
>> index b52d340..e427b0a 100755
>> --- a/scripts/kernel-doc
>> +++ b/scripts/kernel-doc
>> @@ -279,6 +279,7 @@ my $doc_special = "\@\%\$\&";
>>  my $doc_start = '^/\*\*\s*$'; # Allow whitespace at end of comment start.
>>  my $doc_end = '\*/';
>>  my $doc_com = '\s*\*\s*';
>> +my $doc_cont = $doc_com . '\.\.\.\s*(.+)';
> 
> how about making this
> 
> $doc_cont = $doc_com.'\s*([^@].*)';
> 
> That way anything that doesn't begin with a variable declaration would
> be treated as comment continuation.  Might need a \s is the brackets to
> ensure blank lines are OK and not treated as continuations.

The goal should be to accept what is currently in the kernel source tree IMO,
and this suggestion looks like it would support that.

~Randy
