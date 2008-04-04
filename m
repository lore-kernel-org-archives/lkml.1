Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbYDDAbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbYDDAbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYDDAbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:31:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:29890 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbYDDAbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:31:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,600,1199692800"; 
   d="scan'208";a="312488662"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [>=2.6.23][BUG] Oops on power disconnection
Date: Thu, 3 Apr 2008 17:31:12 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEED0EA3C@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1207256678.6024.90.camel@linux-2bdv.site>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [>=2.6.23][BUG] Oops on power disconnection
Thread-Index: AciVzlNbsKcQ5qbTSUmbH+3ZYOiklgAGohOA
References: <5681ec900803300645l5369cda4g119957a4b7f05d17@mail.gmail.com> <5681ec900803300651m6e5f38deke1b7746236e5bb9@mail.gmail.com> <20080402001418.aad6eed2.akpm@linux-foundation.org> <5681ec900804020608o62be52c4ted172e18daf24f5b@mail.gmail.com> <1207147729.30061.9.camel@hammer1.suse.de> <5681ec900804020913t4adc38b1r2e424fa8bbdda241@mail.gmail.com> <1207159974.4700.6.camel@queen.suse.de> <5681ec900804030915w720f3ccfp74e5d501ca3d6b56@mail.gmail.com> <1207256678.6024.90.camel@linux-2bdv.site>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <trenn@suse.de>, "Sanjeev Aditya Naga" <sanjeev.kernel@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>
X-OriginalArrivalTime: 04 Apr 2008 00:28:53.0795 (UTC) FILETIME=[DCB75F30:01C895EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m340Vsnq017215

 

>-----Original Message-----
>From: Thomas Renninger [mailto:trenn@suse.de] 
>Sent: Thursday, April 03, 2008 2:05 PM
>To: Sanjeev Aditya Naga
>Cc: Andrew Morton; linux-kernel@vger.kernel.org; 
>linux-acpi@vger.kernel.org; Pallipadi, Venkatesh; Li, Shaohua
>Subject: Re: [>=2.6.23][BUG] Oops on power disconnection
>
>
>On Thu, 2008-04-03 at 21:45 +0530, Sanjeev Aditya Naga wrote:
>> Hello Thomas,
>> 
>> On Wed, Apr 2, 2008 at 11:42 PM, Thomas Renninger 
><trenn@suse.de> wrote:
>> >
>> > On Wed, 2008-04-02 at 21:43 +0530, Sanjeev Aditya Naga wrote:
>> >  > Hello Thomas,
>> >  >
>> >  > > Hi,
>> >  > >
>> >  > >
>> >  > >  On Wed, 2008-04-02 at 18:38 +0530, Sanjeev Aditya Naga wrote:
>> >  > >  > Hello Andrew Morton,
>> >  > >  >
>> >  > >  > Greetings!
>> >  > >  >
>> >  > >  > Thank you for the update. Is there anything I can do
>> >  > >  > from my side?
>> >  > >  >
>> >  > >  > I thought it was a acpi (dsdt) problem. And based on
>> >  > >  > a tutorial, I have tried to extract, fix, 
>recompile the dsdt
>> >  > >  > and use it with the kernel. But still I have the 
>same problem.
>> >  > >  > Let me know if I shall attach the dsdt (original) 
>decompiled
>> >  > >  > code, if that helps.
>> >  > >
>> >  > >  this could be due a general memory corruption 
>problem through ACPICA.
>> >  > >  If you get different backtraces on reboots even you 
>only modified things
>> >  > >  that do not have to do with the problem, it's 
>probably that and related
>> >  > >  to:
>> >  > >  ï»¿http://bugzilla.kernel.org/show_bug.cgi?id=10339
>> >  > >
>> >  > >  You might want to try the latest kernel or the patch 
>posted there.
>> >  >
>> >  > Thank you for the update.
>> >  > I have checked the bug and unfortunately its not the
>> >  > same issue. Things work absolutely fine, when I'm
>> >  > running on AC power. It even displays the exact
>> >  > battery (and charging) status to me. It messes up
>> >  > when suddenly AC power gets disconnected and
>> >  > switches to battery mode (The time when I get Oops).
>> >  > The system is still usable after switching to battery
>> >  > mode and I still get correct battery stats until its
>> >  > completely discharged. However most of the commands
>> >  > like kill, poweroff, java doesn't work after the Oops.
>> >  The bug is not related to battery, but to AML parsing and 
>can therefore
>> >  affect anything which is ACPI related.
>> >
>> >
>> >  > BTW there is one similarity with the referenced bug.
>> >  > If I boot the computer without AC Power, it gives the
>> >  > same Oops and stops during booting itself.
>> >  >
>> >  > I shall try the latest kernel once and shall update you.
>> >  That would be great.
>> >  If it works, please give the patch there a try, IMO this 
>one should see
>> >  2.6.2[34].X stable kernels soon.
>> 
>> I have got the lastest kernel 2.6.25-rc8 today. I observed that
>> the referenced patch is already in the kernel. However this didn't
>> solve the problem in question. I get the same Oops on this kernel
>> as well. Find the latest dmesg along with the Oops:
>Ok.
>Maybe best is you document the backtraces/oopses with kernel 
>versions at
>bugzilla.kernel.org and add dmesg and acpidump.
>It seems your machine notifies OS that the C-state table changed.
>AFAIK this is rare and there might be a general bug in the 
>cpuidle layer
>which I do not know well.
>Best you add Venkatesh and Shaohua Li <shaohua.li@intel.com> to CC of
>the bug.
>While the backtrace shows a lot, cpuidle IMO is missing a general debug
>option like in the cpufreq layer.
>I couldn't find a single printk in the whole cpuidle/{cpuidle,sysfs}.c
>files, even on error paths. ï»¿Also in the cpuidle specific parts of
>drivers/acpi/processor_idle.c some debug printks may help for 
>future bug
>reports. It is very hard to guess what happened...
>

This looks like cpuidle and kobject interaction.
The latest oops looks different from the original one. Latest one is a
warn_on in lib/kref.c:43

We (Me or Shaohua) will take a deeper look at get back on this.

Thanks,
Venki

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
