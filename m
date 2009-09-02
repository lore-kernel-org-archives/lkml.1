Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbZIBSW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbZIBSW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 14:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZIBSW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 14:22:56 -0400
Received: from exprod6ob113.obsmtp.com ([64.18.1.30]:48454 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753136AbZIBSW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 14:22:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 7/7] printk: provide a filtering macro for printk
Date: Wed, 2 Sep 2009 14:22:52 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901C55DE5@mi8nycmail19.Mi8.com>
In-Reply-To: <4A9EA5C9.3010900@am.sony.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 7/7] printk: provide a filtering macro for printk
Thread-Index: Acor75v8HIhlfyVuTKOF49bLcG5jPQACk8cg
References: <1251844269-12394-1-git-send-email-mat@brain-dump.org> <1251844269-12394-8-git-send-email-mat@brain-dump.org> <4A9DAD2B.3080909@am.sony.com> <BD79186B4FD85F4B8E60E381CAEE190901C55CD3@mi8nycmail19.Mi8.com> <20090902130943.GE2736@debbook.brain-dump.org> <4A9EA5C9.3010900@am.sony.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Tim Bird" <tim.bird@am.sony.com>,
       "Marc Andre Tanner" <mat@brain-dump.org>
Cc: <linux-embedded@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "linux kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Sep 2009 18:22:56.0064 (UTC) FILETIME=[64744400:01CA2BFA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n82INN16028363

On Wednesday, September 02, 2009 10:05 AM, Tim Bird wrote:
> Marc Andre Tanner wrote:
>> On Tue, Sep 01, 2009 at 07:32:25PM -0400, H Hartley Sweeten wrote:
>>> On Tuesday, September 01, 2009 4:24 PM, Tim Bird wrote:
>>>> Some places in the kernel break the message into pieces, like so:
>>>>
>>>> printk(KERN_ERR, "Error: first part ");
>>>> ...
>>>> printk(" more info for error.\n");
>>> Technically, shouldn't the second part of the message actually be:
>>>
>>> printk(KERN_CONT " more info for error.\n");
>>>
>>> Maybe some mechanism could be created to handle the continued message
>>> if they have the KERN_CONT?
>> 
>> Yes it's true that KERN_CONT isn't handled correctly, but I don't see a way
>> to change that.
>> 
>>>> These parts would not be handled consistently under certain
>>>> conditions.
>>>>
>>>> It would be confusing to see only part of the message,
>>>> but I don't know how often this construct is used.  
>> 
>> $ grep -R KERN_CONT linux-2.6 | wc -l
>> 373
>> 
>>>> Maybe
>>>> another mechanism is needed to ensure that continuation
>>>> printk lines have the same log level as their start strings.
>> 
>> I currently don't see a way to achieve this with the CPP.
>
> If it's that few, then maybe it's OK to actually change
> the code for those printk statements. (Heck, these locations
> were all changed in the last 2 years anyway.)
> 
> I'm just brainstorming here, but how about changing them from:
>   printk(KERN_INFO "foo");
>   printk(KERN_CONT "bar\n");
> to:
>   printk(KERN_INFO "foo");
>   printk_cont(KERN_INFO "bar\n");
> 

Unfortunately not all the continued printk statements in the kernel are
properly tagged with KERN_CONT (or pr_cont, etc.).

> This way the continuation line has the log level, and can
> be conditionally compiled based on the VERBOSITY level.  A little
> magic would be needed to strip the first 3 chars of the fmt
> string in printk_cont().
> 
> I think this makes the printk messages a bit more consistent anyway,
> and still marks lines that are continuation lines.
> 
>>>> But, overall, very slick!  It's nice to see a solution that doesn't
>>>> require changing all printks statements in the kernel.
>> 
>> Yes that's what I thought too. Thanks to the comments so far the next 
>> version of the patch will contain even less changes to the rest of the 
>> kernel.
>>  
>>> I haven't looked over this patch series yet but does it work with the
>>> pr_<level> macros (pr_info, pr_err, etc.)?
>> 
>> It should work, yes.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
