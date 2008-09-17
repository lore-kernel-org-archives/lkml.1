Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYIQMI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYIQMI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 08:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYIQMIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 08:08:48 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:43865 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbYIQMIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 08:08:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 6/6] x86: add KERN_APIC
Date: Wed, 17 Sep 2008 14:08:41 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com> <1221640067-24389-7-git-send-email-yhlu.kernel@gmail.com> <20080917083809.GB24035@elte.hu> <20080917083809.GB24035@elte.hu> <86802c440809170145s317e6ef8xad352e3a306abe45@mail.gmail.com>
In-reply-To: <86802c440809170145s317e6ef8xad352e3a306abe45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171408.42244.elendil@planet.nl>
X-OriginalArrivalTime: 17 Sep 2008 12:08:45.0193 (UTC) FILETIME=[221CB790:01C918BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Sep 17, 2008 at 1:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>> -             printk(KERN_WARNING "APIC calibration not consistent "
>>> +             printk(KERN_WARNING KERN_APIC "APIC calibration not
>>> consistent "
>>
>> here too the question arises: what should the semantics of the 'mixing'
>> of such subsystem printk tags with the classic priority tags be. I
>> think in this particular case we dont want the KERN_APIC tag, as that
>> would prevent this failure message to be printed by default. I.e. this
>> line should remain:
>>
>>> -             printk(KERN_WARNING "APIC calibration not consistent "
>>
>> to make sure this warning always shows up in the logs. Agreed?
>
> with
> DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 6); 
> the KERN_WARNING <5> will be showing up that warning, even without
> loglevl=apic:8
> 
> or change that  to
> DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 7);

Are you suggesting that each subsystem define its own default log level? 
That sounds truly horrible. It would mean that when reading code or 
adding new messages you'd always have to check what the default loglevel 
is for a particular subsystem.

I really like the idea of being able to easily increase the verbosity for 
a particular subsystem, but please make sure that by default all messages 
with the same level are treated the same, irrespective of which subsystem 
they belong to.

So IMO
       printk(KERN_WARNING "APIC calibration not consistent "
and
       printk(KERN_WARNING KERN_APIC "APIC calibration not consistent "
should do exactly the same thing if no 'loglevel=apic:X' is used and that 
should be guaranteed for all subsystems.

Cheers,
FJP
