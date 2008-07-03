Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbYGCMKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbYGCMKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbYGCMKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:10:35 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:23448 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbYGCMKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:10:34 -0400
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:10:34 EDT
Message-ID: <486C9AD2.6020604@debian.org>
Date: Thu, 03 Jul 2008 11:24:34 +0200
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Selbak, Rolla N" <rolla.n.selbak@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: Intel Microcode loader, tg3 driver, and the -rc8-mmotd New World
 Order firmware...
References: <4534.1215048758@turing-police.cc.vt.edu>            <Pine.LNX.4.61.0807030716030.10434@ginsburg.homenet> <32146.1215066947@turing-police.cc.vt.edu> <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
In-Reply-To: <Pine.LNX.4.61.0807030743230.10608@ginsburg.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2008 09:24:38.0601 (UTC) FILETIME=[9DB10390:01C8DCEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Arjan and the relevant Intel contact]

Tigran Aivazian wrote:
> On Thu, 3 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
> 
>> On Thu, 03 Jul 2008 07:17:16 BST, Tigran Aivazian said:
>>> Hi Valdis,
>>>
>>> On Wed, 2 Jul 2008 Valdis.Kletnieks@vt.edu wrote:
>>>
>>>> I built the -rc8-mmotd kernel, and built it with 
>>>> 'CONFIG_FIRMWARE_IN_KERNEL
>> =n'.
>>>> Lo and behold, the microcode.ko was now doing a request_firmware for
>>>> 'intel-ucode/06-0f-06' (which makes sense, the Core2 Duo in this 
>>>> laptop is
>>>> family 6, model 15, stepping 6).  However, what I had in 
>>>> /lib/firmware was
>>>> the Intel-distributed 'microcode.dat' with updates for all the CPUs 
>>>> (which
>>>> used to work in times past).
>>>>
>>>> What's the magic incantation to take the microcode.dat and create 
>>>> something
>>>> that the firmware driver is willing to use, or is this all borked up 
>>>> and
>>>> I need to do a major rethink or fix my config?
>>>
>>> that's because it expects the Intel-supplied microcode data and you are
>>> using the old style microcode.dat data.
>>
>> I fed it the stuff I downloaded today from this URL:
>>
>> http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=2643&OSFullName=Linux*&lang=eng&strOSs=39&submit=Go! 
>>
>>
>> which gets me a microcode-20080401.dat that does the same thing.  Is 
>> there
>> some *other* Intel-supplied microcode data I should be getting instead?
> 
> Oh, sorry, I assumed that Intel distribute the data in the format that 
> driver expects.

There are two format of Intel CPU microcode and two methods to load it.
- old: the microcodes are in a big file, which include multiple
   microcodes (for multiple CPU).  The driver require a char device
   and a user space loader ("microcode_ctl")
- new: one microcode per file, using the 'request_firmware'
   infrastructure. No user space support needed.

Actually Intel provides only the old methods.
There was talks with Arjan and Intel about the distribution format
for the new methods. But I don't have any new.
I think that when the new format is fully specified (directory
structure, tar, gzip,...) Intel will distribute the microcodes
in the new form.

ciao
	cate

