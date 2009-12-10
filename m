Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbZLJShz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbZLJShz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761311AbZLJShy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:37:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:16408 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761300AbZLJShx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:37:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qeE9bKXK9s6jeUNq79pfJlMP06rQyRwG9lAQVWamSblCw8zj+gZOvIc87Mn42jdxQy
         dYnt1OZXUolAg3ycplwze7dTLcsVbDfhpS9+9ynR50d1wUHW3oLll4oTxT4W5D6qpfFR
         ANj56BbYmSTNpGNwTz6tWsKj2tmUTvo5rAA5c=
Message-ID: <4B214007.2080409@gmail.com>
Date: Thu, 10 Dec 2009 21:37:59 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Xiaotian Feng <dfeng@redhat.com>, lenb@kernel.org, ming.m.lin@intel.com,
       robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or in_atomic
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com> <20091210100907.GA2446@ucw.cz> <4B2136D5.1030402@gmail.com> <20091210181800.GM19454@elf.ucw.cz>
In-Reply-To: <20091210181800.GM19454@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek пишет:
> On Thu 2009-12-10 20:58:45, Alexey Starikovskiy wrote:
>   
>> Hi Pavel,
>>
>> Please elaborate... Your comments "ugly as hell" are too often to be
>> specific...
>> There is only one use of ACPI_PREEMPTION_POINT(), and it is in the
>> ACPICA code,
>> which we all agreed to keep OS independent, thus the need for #define.
>> Do you see any other way to add preemption point without introducing
>> Linux-specific
>> code into ACPICA?
>>     
>
> I believe we want linux-specific code in acpica at this point.
>
>   
The point there we call cond_resched() in ACPICA is an interpreter parse
loop. This parse loop may be executed from within atomic context and even
with interrupts off. In this case, cond_resched() should not be called
to not make
might_sleep() guards angry.

Please post the code, which will do the above and will not look "ugly as
hell".
I still don't follow your vague comments.
> (Or maybe... I guess other systems have concept of preemption and not
> all actions are permitted from all contexts, so maybe something like
> that would be important for them, too?)
>   
None of them cared about it up to this point.
With the macro above we allowed them to follow Linux, but to go or not
is their call.

Regards,
Alex.
