Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZKBKsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZKBKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZKBKsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:48:25 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:41228 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZKBKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z5Frp8OjrnkOfsHCZ72KJ7m9Ha6bBgjltC9iYmIGPIfas6i7Wh6621ZtSqWDqLMkj3
         6vLKCWQnSxvEBcJUB1qFPPnZBZ63KsZJXagFhOJOUKXuEP60TVBDhZGwXqG3qnGxY3cI
         TEDYCHf9PGPr5UkRmfB/HHv+xICMpZqTLZkcA=
MIME-Version: 1.0
In-Reply-To: <20091102093840.GA11426@elf.ucw.cz>
References: <20091031013427.GL14091@buzzloop.caiaq.de>
	 <20091101205449.GT14091@buzzloop.caiaq.de>
	 <20091101213343.GA31345@elf.ucw.cz>
	 <20091101220341.GA16698@elf.ucw.cz>
	 <771cded00911020122o3bb5cc96q957c8be1ce7cae46@mail.gmail.com>
	 <20091102093840.GA11426@elf.ucw.cz>
Date: Mon, 2 Nov 2009 06:48:28 -0400
Message-ID: <771cded00911020248s2b2b6577o5ec2f3772a09e7b9@mail.gmail.com>
Subject: Re: Possible suspend/resume regression in .32-rc?
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: dsaxena@laptop.org, alan@linux.intel.com, gregkh@suse.de,
       Daniel Mack <daniel@caiaq.de>, linux-arm-kernel@lists.infradead.org,
       Eric <eric.y.miao@gmail.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com, dbaryshkov@gmail.com, omegamoon@gmail.com,
       utx@penguin.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 5:38 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2009-11-02 05:22:30, Haojian Zhuang wrote:
>> On Sun, Nov 1, 2009 at 6:03 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>
>> Em, it's not caused by the IRQ patch.
>>
>> The kernel is blocked in resume path. When console is resumed, IRQ is
>> already disabled and system is blocked. Actually, IRQ shouldn't be
>> disabled at here. Up to now, I only find which patch will cause this
>> issue. But I can't find the best solution on it. The patch with issue
>> is pasted in below.
>>
>> So this issue is only occused when console suspend is enabled. If you
>> enable no_console_suspend in command, you won't meet this issue. It
>> seems that it's caused by removing termios setting in
>> uart_resume_port() in the below patch. If I add these code back, the
>> issue doesn't occur any more.
>
> Given that it hangs very early, in arch_suspend_enable_irqs() (see my
> other mail), I don't trust your analysis.
>
> I'm not using serial console on spitz, and I have never had successful
> resume with the patch applied.

It seems that we're talking on different issue with similar symptom.
Please check my test method. While I'm testing suspend with devices
level, kernel is blocked in console resume. In this level, it won't
call arch_suspend_enable_irqs(). This function call is only invoked in
processor level or below.

Up to now, I can't reproduce the issue you're talking on my platform
yet. I'll check this issue continuously. I also want to know your
hardware information.

Thanks
Haojian
