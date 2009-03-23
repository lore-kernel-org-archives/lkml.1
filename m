Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZCWHQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZCWHQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZCWHQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:16:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:53092 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZCWHP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Rx1cVwb0v/LzDzUUn3IbQ4o8eCs7bsr/kxoHedg0HmUbmnNcX771MG3iXpzWNvCKnq
         O1/TNkCRjHWgn26tN1r2WVFu7Jm7CHAHy66kXxgkh8fNRySUwDUh5uw6yNguGtNAQM3p
         77tjVRjYMX9OwTGLqYSd7+oMCJvIMyhj3txl4=
MIME-Version: 1.0
In-Reply-To: <20090320185851.GB1418@ucw.cz>
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
	 <20090320185851.GB1418@ucw.cz>
Date: Mon, 23 Mar 2009 15:15:57 +0800
X-Google-Sender-Auth: d11980922ce466d4
Message-ID: <2a27d3730903230015h6cc320bek423764eb496d6b30@mail.gmail.com>
Subject: Re: nonboot cpu on SMP suspend
From: Li Yang <leoli@freescale.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 2:58 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2009-03-18 14:25:32, Li Yang wrote:
>> Hi all,
>>
>> I'm curious why we need to un-plug all the nonboot cpus before suspend
>> and start them all over again after the suspend(ACPI sleep)?  I mean
>> if we can bring the booting cpu back to the exact state as before
>> suspend, why can't we just do the same for non-booting cpus?  And that
>> will be much faster.  Any thought?  Thanks.
>
> Why do you think it will be faster?

_cpu_down() and _cpu_up() are surely complex functions, involving
work_queues and synchronization between boot cpu and non-boot cpu.  On
the contrary, to bring the cpu back to previous state is much simpler.
 For standby state, you barely need to do anything.  For mem state,
you only need to restore the registers and states of the CPU.

- Leo
