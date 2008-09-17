Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYIQQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYIQQXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYIQQXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:23:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:57650 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYIQQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=rl/IOV6HRTUp8wRqE10Tj5yrP4JMqkUEdbJP4hDeod82xCV0NhGhV/yWpo5EiuypUc
         FL5rToXDlPgJ/ZPmzE8LWNLMD6Xy6dztX+g3yZLE+czHSC6Mk3cceCjcCxMWPtRtNr95
         5F2b/jQOjmkY4Vu4l5r9jq7WYf6CdmFaRk8nY=
Message-ID: <86802c440809170923q227dda81t30f2c364ed17afd7@mail.gmail.com>
Date: Wed, 17 Sep 2008 09:23:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v5
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080917084754.GC24035@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221635415-14859-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080917073058.GA3770@x200.localdomain>
	 <20080917084754.GC24035@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 1:47 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>> On Wed, Sep 17, 2008 at 12:10:09AM -0700, Yinghai Lu wrote:
>> >     KERN_PCI
>> >     KERN_ACPI
>> > v4: fix some checkpatch error and warning
>> > v5: add default with DEFINE_LOGLEVE_SETUP_DEF
>> >     KERN_APIC
>> >
>> > usage:
>> >     in .h to have
>> >             #define KERN_PCI "<pci>"
>> >     in .c to have
>> >             DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
>> >     then could use
>> >             printk(KERN_DEBUG KERN_PCI fmt, ...);
>> >     and command line
>> >             loglevel=3,pci:8
>> >
>> > you can add different printk to different files of one subsys if you like
>> > not just one susbsys one tag, and don't need to update kernel.h to add more tags
>>
>> I think all of this is overdesigned and stupid.
>>
>> People expecting that loglevels are exactly right so they can calm
>> messages are like security-savvy people who expect all security
>> relevant bugfixes carry CVE tag.
>>
>> grep says there are 50757 printk calls, only 32129 of them carry KERN_
>> tag.
>>
>> Oh, and new and improved logs:
>>
>>       [    0.340326] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
>>       [    0.340326] pci 0000:00:01.0: PME# disabled
>>       [    0.340326] <pci>PCI: 0000:00:1a.0 reg 20 io port: [dc00, dc1f]
>>       [    0.340413] <pci>PCI: 0000:00:1a.1 reg 20 io port: [e000, e01f]
>>       [    0.340549] <pci>PCI: 0000:00:1a.7 reg 10 32bit mmio: [febffc00, febfffff]
>>                      ^^^^^^^^^

> and it's bad and a showstopper if the default output of 'dmesg'
> degrades, like your noticed - those are bugs in the concept and need to
> be fixed.

v6 should fix the problem, to support several seperate loglevel.

YH
