Return-Path: <linux-kernel-owner+w=401wt.eu-S1762757AbYHEXyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762757AbYHEXyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYHEXxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:53:53 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:15475 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbYHEXxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f7/53paj6rLklbrJO3qd/+UkC9fB6dO93ruktuP5iCKbYwQ+b9PXXK/Nuvjc6hGJRP
         yVsLJuTrmm3FahSEXnyNEizYk7KFJbxj6kxPn9zLuzSiDS1+bCkrDAMZjDkXTJMiuxov
         qCzT11LcC9LUy4dE2Iv1AHS3NWKYa+0Fx7p+Q=
Message-ID: <86802c440808051653g2ef28df7h7615301f6db0b4f5@mail.gmail.com>
Date: Tue, 5 Aug 2008 16:53:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/25] dyn_array and nr_irqs support v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Mike Travis" <travis@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4898E1B4.60101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	 <4898DBD8.4000002@zytor.com>
	 <86802c440808051615h57baa06ci5ab040048786b50d@mail.gmail.com>
	 <4898E1B4.60101@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 4:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>>
>> i am working on dyn_array + condense irq_desc/irq_cfg.
>>
>> it will use dyn_array to allocate 32 entry for irq_desc/irq_cfg, and
>> will use get_irq_desc via list to distribute it. later if need more,
>> will allocate more 32 entries....
>>
>> so will send out v4.
>>
>
> My understanding of dyn_array is that it only works at init time.
> How does that work when you hotplug MSI-X devices?

actually create irq_desc like Eric suggest, but allocate 32 entry one
time, and use it one by one. share some init work function bewteen
init stage and later.

YH
