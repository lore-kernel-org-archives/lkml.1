Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZBEKuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZBEKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZBEKuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:50:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:5963 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZBEKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:50:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RU83lcuWwjauxsLcrgHNCAqtsKYyCkY3cFvY1ZD8UmZy7t5mgZGHdNejSYnoN7tP+7
         lZdU8MdgNzDGAeNUpLu07U2Zql876D/2HZu4CHl73tYmxmHdcxrfpF398RyCeCW5x9YJ
         TUkRk94K+wB+kLiVoY+yyn5E7uGJQNkfhMe/o=
MIME-Version: 1.0
In-Reply-To: <jeab91w54x.fsf@sykes.suse.de>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	 <20090204221451.GA27254@uranus.ravnborg.org>
	 <adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
	 <adaskmtjsnn.fsf@cisco.com>
	 <56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
	 <56e1b5710902050215l5b34adb1ofb8a972318ebe353@mail.gmail.com>
	 <jeab91w54x.fsf@sykes.suse.de>
Date: Thu, 5 Feb 2009 11:50:02 +0100
Message-ID: <56e1b5710902050250u244a7499k90ad1825ee85bbad@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 11:27 AM, Andreas Schwab <schwab@suse.de> wrote:
> Floris Kraak <randakar@gmail.com> writes:
>
>> Example:
>>
>> kernel/power/main.c:717: warning: format not a string literal and no
>> format arguments
>>
>> This complains about:
>> ..
>>         if (!rtc) {
>>                 printk(warn_no_rtc);
>>                 goto done;
>>         }
>> ..
>>
>> So what is this "warn_no_rtc" thing?
>>
>>         static char             warn_no_rtc[] __initdata =
>>                 KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
>
> Does it help to make it const?
>
>> That's pretty much GCC failing to recognize that the format is a
>> string literal and then complaining that it isn't.
>
> Since it's a non-const variable it cannot be a string literal.
>

kernel/power/main.c:698: error: warn_no_rtc causes a section type conflict

Nice try ;-)

Replacing __initdata with __devinitconst sounded like it might solve
things ( - http://mail.nl.linux.org/kernelnewbies/2008-02/msg00042.html,
interesting reading) but alas, the warning persists.

(apologies to Andreas for the resend)

Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
