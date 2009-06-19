Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZFSBuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZFSBuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 21:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZFSBty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 21:49:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:41509 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZFSBtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 21:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tsoWJQtSS8DgsVzmz0PBszbCWJIAdHmdwxMd/GDBl/ot6kcbrk2oadkwUhJ4CLdalS
         NPfvPuDgiNDgUkUYOH4NkSLm0WM5HGf2rO7fUBsadPS/6l0LHWO9W962uVWkd5GMznea
         gWBq07OoSokMhvrJ79naUD37V/9b7D0RsWIx8=
Message-ID: <4A3AEED7.90804@gmail.com>
Date: Thu, 18 Jun 2009 19:50:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Run-time PM idea (was: Re: [RFC][PATCH 0/2]   PM: Rearrange core
 suspend code)
References: <200906072347.00580.rjw@sisk.pl> <20090608065419.GA13568@elte.hu>	<200906081330.50045.rjw@sisk.pl> <20090608130509.GA3272@elte.hu>	<20090608131159.GA15100@srcf.ucam.org>	<20090608132235.GC13214@elte.hu>	<20090608133215.GA15482@srcf.ucam.org>	<20090608134647.GA14234@elte.hu>	<20090608135431.GA16052@srcf.ucam.org>	<20090608142450.GE14234@elte.hu> <20090608143513.GB16752@srcf.ucam.org>
In-Reply-To: <20090608143513.GB16752@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2009 08:35 AM, Matthew Garrett wrote:
> On Mon, Jun 08, 2009 at 04:24:50PM +0200, Ingo Molnar wrote:
>> * Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>> eSATA is pretty common now.
>> [ And 99% of the CPUs have an IDT still 99.9% of the users dont know
>>    what it is :) ]
>
> Users know that there's a socket on the front of their computer that
> they can plug a hard drive into, and if that doesn't work then they're
> going to be upset.
>
>>> The problem with this kind of default is that you get people who
>>> are confused that their hardware doesn't work.
>> If the hardware 'doesnt work' that is a kernel bug. Hardware that
>> _cannot be suspended_ safely (physically) should not be
>> auto-suspended, of course.
>
> So, like I said, the kernel can't automatically suspend AHCI unless it's
> received some information from elsewhere that tells it it's ok to. The
> kernel can't know if there's an eSATA port or not.
>
>>> If the kernel doesn't have enough information to make a decision
>>> it should err on the side of functionality - we're talking about
>>> fairly low-level power savings, but potentially several years of
>>> aggregate confusion on the part of users.
>> the difference between a 10W and a 1W footprint is a long series of
>> 'low-level power savings'.
>>
>> If users are getting confused and if hardware gets broken then tha's
>> a plain bug and the wrong path is being walked.
>
> Yes. And powersaving is a tradeoff between functionality and power
> consumption. The kernel doesn't know what level of functionality a given
> user requires. It *can't* know that itself.
>
>>> Users are generally ok at realising correlation between a setting
>>> change and something no longer working, so as long as you provide
>>> that they'll be happy. I agree that this sucks. What we actually
>>> want is some means of reliably identifying whether a port is
>>> hotplug or not, but eSATA makes this very difficult.
>> Is it impossible?
>
> To the best of my knowledge, yes.

Well, in some cases we can get an idea - the current AHCI spec has bits 
in the PxCMD register (External SATA Port and Hot Plug Capable Port) 
which can indicate which ports are externally accessible and thus are 
likely to receive hotplug events. Of course, these are supposed to be 
programmed by the BIOS based on the particular motherboard/machine, and 
we all know how accurate BIOS-reported information can be..
