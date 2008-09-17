Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYIQQam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYIQQam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYIQQae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:30:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:58705 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYIQQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XllOUAQCTJFpjBDysYFbU2ZdFFTMnpo5AsqjIzkyZ+KzOLaMwbGNy0FELppuOn+G0B
         vWcdVq8I/DgLb2FNW51HHOwKOLv1IdyoWB/dMQ9WUNFduItlZtD8ffvO1bPrdcEWHnCh
         Aza8GuUQiUyXgXN+mY5OBHwZAPDNaz+B8HNMQ=
Message-ID: <86802c440809170930m21f09879q3aa4edf2a32879f6@mail.gmail.com>
Date: Wed, 17 Sep 2008 09:30:32 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH 6/6] x86: add KERN_APIC
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809171408.42244.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221640067-24389-7-git-send-email-yhlu.kernel@gmail.com>
	 <20080917083809.GB24035@elte.hu>
	 <86802c440809170145s317e6ef8xad352e3a306abe45@mail.gmail.com>
	 <200809171408.42244.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 5:08 AM, Frans Pop <elendil@planet.nl> wrote:
> Yinghai Lu wrote:
>> On Wed, Sep 17, 2008 at 1:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>>> -             printk(KERN_WARNING "APIC calibration not consistent "
>>>> +             printk(KERN_WARNING KERN_APIC "APIC calibration not
>>>> consistent "
>>>
>>> here too the question arises: what should the semantics of the 'mixing'
>>> of such subsystem printk tags with the classic priority tags be. I
>>> think in this particular case we dont want the KERN_APIC tag, as that
>>> would prevent this failure message to be printed by default. I.e. this
>>> line should remain:
>>>
>>>> -             printk(KERN_WARNING "APIC calibration not consistent "
>>>
>>> to make sure this warning always shows up in the logs. Agreed?
>>
>> with
>> DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 6);
>> the KERN_WARNING <5> will be showing up that warning, even without
>> loglevl=apic:8
>>
>> or change that  to
>> DEFINE_LOGLEVEL_SETUP_DEF(apic, KERN_APIC, "apic:", 7);
>
> Are you suggesting that each subsystem define its own default log level?
> That sounds truly horrible. It would mean that when reading code or
> adding new messages you'd always have to check what the default loglevel
> is for a particular subsystem.

could be done.
SPEW: 8
???:9

current msg_loglevel is limted to one digital

YH
