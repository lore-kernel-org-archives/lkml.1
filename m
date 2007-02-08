Return-Path: <linux-kernel-owner+w=401wt.eu-S1423112AbXBHQfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423112AbXBHQfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423222AbXBHQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:35:24 -0500
Received: from artemis.sr.unh.edu ([132.177.249.69]:23981 "EHLO
	artemis.sr.unh.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423112AbXBHQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:35:23 -0500
X-Greylist: delayed 1958 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 11:35:23 EST
Message-ID: <45CB4996.1050903@unh.edu>
Date: Thu, 08 Feb 2007 11:02:30 -0500
From: Kai Germaschewski <kai.germaschewski@unh.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Philippe De Muyter <phdm@macqel.be>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Joe Perches <joe@perches.com>, kkeil@suse.de, kai.germaschewski@gmx.de,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
References: <20070206160446.GE8991@Ahmed> <1170784337.3688.18.camel@localhost> <20070206204130.GU8991@Ahmed> <20070206211813.GD2649@ingate.macqel.be> <45CB4766.30909@tmr.com>
In-Reply-To: <45CB4766.30909@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Philippe De Muyter wrote:
>> On Tue, Feb 06, 2007 at 10:41:30PM +0200, Ahmed S. Darwish wrote:
>>> On Tue, Feb 06, 2007 at 09:52:17AM -0800, Joe Perches wrote:
>>>> On Tue, 2007-02-06 at 18:04 +0200, Ahmed S. Darwish wrote:
>>>>> A patch to use ARRAY_SIZE macro already defined in kernel.h
>>>>> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
>>> [...]
>>>>> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>>>>> +    int nelem = ARRAY_SIZE(procfsentries);
>>>>>      int i;
>>>>>  
>>>>>      for (i=0; i < nelem; i++) {
>>>> For these patches, perhaps you can eliminate the temporary
>>>> variable and change the loop to the more common form of
>>>>
>>>>     for (i = 0; i < ARRAY_SIZE(array); i++) {
>>> Thanks, I think it's better too. Here's the modified patch.
>>>
>>> A patch to use ARRAY_SIZE macro when appropriate.
>>>
>>> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
>>> ---
>>> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
>>> index d22c022..87fe89c 100644
>>> --- a/drivers/isdn/capi/capi.c
>>> +++ b/drivers/isdn/capi/capi.c
>>> @@ -1456,10 +1456,9 @@ static struct procfsentries {
>>>  
>>>  static void __init proc_init(void)
>>>  {
>>> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>>>      int i;
>>>  
>>> -    for (i=0; i < nelem; i++) {
>>> +    for (i = 0; i < ARRAY_SIZE(procfsentries); i++) {
>>>          struct procfsentries *p = procfsentries + i;
>>>      p->procent = create_proc_entry(p->name, p->mode, NULL);
>>>      if (p->procent) p->procent->read_proc = p->read_proc;
>>> @@ -1468,10 +1467,9 @@ static void __init proc_init(void)
>>>  
>>>  static void __exit proc_exit(void)
>>>  {
>>> -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
>>>      int i;
>>>  
>>> -    for (i=nelem-1; i >= 0; i--) {
>>> +    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
>>
>> I would write such decrementing loops as :
>>
>>        for (i = ARRAY_SIZE(procfsentries); --i >= 0; ) {
>>
>> Long time ago, that produced better code.  I did not check recently
>> though.
>
> Why would you write "--i >= 0" instead of just "i--"? The size of an
> array can't be negative.
>
In my opinion, the first way of writing it is the way to go. I've not
seen it put like the 2nd or 3rd way anywhere in the kernel (of course I
haven't read all of the code), and while it's correct, it's less
readable. I don't think gcc would generate different code between
variant 1 and 2, and anyway, this is called once at module init/exit
time, so whether you save 10 cycles there or not is totally insignificant.

--Kai
