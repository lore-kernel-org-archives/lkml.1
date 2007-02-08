Return-Path: <linux-kernel-owner+w=401wt.eu-S1423092AbXBHPx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092AbXBHPx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423100AbXBHPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:53:26 -0500
Received: from mail.tmr.com ([64.65.253.246]:37468 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423092AbXBHPxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:53:25 -0500
Message-ID: <45CB4766.30909@tmr.com>
Date: Thu, 08 Feb 2007 10:53:10 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.isdn.i4l.user
To: Philippe De Muyter <phdm@macqel.be>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, Joe Perches <joe@perches.com>,
       kkeil@suse.de, kai.germaschewski@gmx.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
References: <20070206160446.GE8991@Ahmed> <1170784337.3688.18.camel@localhost> <20070206204130.GU8991@Ahmed> <20070206211813.GD2649@ingate.macqel.be>
In-Reply-To: <20070206211813.GD2649@ingate.macqel.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Tue, Feb 06, 2007 at 10:41:30PM +0200, Ahmed S. Darwish wrote:
>> On Tue, Feb 06, 2007 at 09:52:17AM -0800, Joe Perches wrote:
>>> On Tue, 2007-02-06 at 18:04 +0200, Ahmed S. Darwish wrote:
>>>> A patch to use ARRAY_SIZE macro already defined in kernel.h
>>>> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
>> [...]
>>>> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>>>> +    int nelem = ARRAY_SIZE(procfsentries);
>>>>      int i;
>>>>  
>>>>      for (i=0; i < nelem; i++) {
>>> For these patches, perhaps you can eliminate the temporary
>>> variable and change the loop to the more common form of
>>>
>>> 	for (i = 0; i < ARRAY_SIZE(array); i++) {
>> Thanks, I think it's better too. Here's the modified patch.
>>
>> A patch to use ARRAY_SIZE macro when appropriate.
>>
>> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
>> ---
>> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
>> index d22c022..87fe89c 100644
>> --- a/drivers/isdn/capi/capi.c
>> +++ b/drivers/isdn/capi/capi.c
>> @@ -1456,10 +1456,9 @@ static struct procfsentries {
>>  
>>  static void __init proc_init(void)
>>  {
>> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>>      int i;
>>  
>> -    for (i=0; i < nelem; i++) {
>> +    for (i = 0; i < ARRAY_SIZE(procfsentries); i++) {
>>          struct procfsentries *p = procfsentries + i;
>>  	p->procent = create_proc_entry(p->name, p->mode, NULL);
>>  	if (p->procent) p->procent->read_proc = p->read_proc;
>> @@ -1468,10 +1467,9 @@ static void __init proc_init(void)
>>  
>>  static void __exit proc_exit(void)
>>  {
>> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>>      int i;
>>  
>> -    for (i=nelem-1; i >= 0; i--) {
>> +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
> 
> I would write such decrementing loops as :
> 
>        for (i = ARRAY_SIZE(procfsentries); --i >= 0; ) {
> 
> Long time ago, that produced better code.  I did not check recently though.

Why would you write "--i >= 0" instead of just "i--"? The size of an 
array can't be negative.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
