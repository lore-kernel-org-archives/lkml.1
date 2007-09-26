Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbXIZS3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbXIZS3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbXIZS3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:29:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXIZS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:29:44 -0400
Message-ID: <46FAA373.9010607@zytor.com>
Date: Wed, 26 Sep 2007 11:22:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andreas Schwab <schwab@suse.de>, Maxim Uvarov <muvarov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, balbir@in.ibm.com,
       jlan@engr.sgi.com
Subject: Re: [PATCH] Since we have counters in __u64 format we have to print
 them with %llu macros.
References: <20070926143918.6749.53939.stgit@localhost.localdomain> <je641x64rw.fsf@sykes.suse.de> <46FA46F6.6000707@linux.vnet.ibm.com>
In-Reply-To: <46FA46F6.6000707@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Andreas Schwab wrote:
>> Maxim Uvarov <muvarov@ru.mvista.com> writes:
>>
>>> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
>>> index cbee3a2..73924df 100644
>>> --- a/Documentation/accounting/getdelays.c
>>> +++ b/Documentation/accounting/getdelays.c
>>> @@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
>>>  void task_context_switch_counts(struct taskstats *t)
>>>  {
>>>  	printf("\n\nTask   %15s%15s\n"
>>> -	       "       %15lu%15lu\n",
>>> +	       "       %15llu%15llu\n",
>>>  	       "voluntary", "nonvoluntary",
>>>  	       t->nvcsw, t->nivcsw);
>> __u64 is not always long long.
> 
> What is the maximum size of long long across all architectures?
> How does one format __u64 for printing?
> 

In user space, use the macro PRIu64 (or PRIx64 etc) from <inttypes.h>.

	-hpa
