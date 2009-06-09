Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZFICdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZFICdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZFICdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:33:45 -0400
Received: from mail-pz0-f171.google.com ([209.85.222.171]:41576 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZFICdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yGKvygttUs3SEwumbHev38IRAjc1CGJORQ+n0hqkMhHEuuEJN9yyPIcbmrny55ng2C
         U59/Oli1bR3tAT4L/BAY7PoPfAGZApRl1P0UHKu3Qhl4uzwidAslNbcrvuxMSllNngs8
         Gm469i/bFpAxEyL3L8ZXkvAAq6cw3eGSf8lFc=
MIME-Version: 1.0
In-Reply-To: <4A2D9282.6080609@simtec.co.uk>
References: <90b950fc0906072153j6308059eq4d6f864c97a2003d@mail.gmail.com>
	 <4A2D9282.6080609@simtec.co.uk>
Date: Tue, 9 Jun 2009 11:33:45 +0900
Message-ID: <90b950fc0906081933s47aa9bd0nded77973396a0109@mail.gmail.com>
Subject: Re: Samsung SoC Framebuffer Driver issue.
From: InKi Dae <daeinki@gmail.com>
To: Ben Dooks <ben@simtec.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Kyungmin Park <kmpark@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are my comments about your answers.
And thank you for your answer.

2009/6/9 Ben Dooks <ben@simtec.co.uk>:
> InKi Dae wrote:
>>
>> Hello,  Ben  Dooks.
>>
>> I am trying to develop Samsung SoC Framebuffer Driver for S5PC100 but
>> I faced some problems about design. so I have some questions about those.
>>
>> there are some differences between LCD Controller registers of S3C64XX
>> and S5PC100 like the following.
>>
>> . regiters not used by S3C64XX were added to S5PC100 also BPP MODE.
>> . WindowX Palette Data Index registers were removed from lcd
>> controller of S3C64XX and Palette Memory Registers were added to one
>> of S5PC100
>>
>>
>> 1.
>> Your framebuffer driver, drivers/video/s3c-fb.c, is related to only
>> S3C64XX.
>> and I'd like to divide framebuffer driver into common logical driver
>> for supporting S3C64XX and S5PC100 and S5PC100 specific driver.
>> but your driver needs to modifying because calling register control
>> commands in s3c-fb.c directly.
>
> Actually, it should also support the s3c2443 driver. You might find some
> interesting answers to the further questions by looking at how that works
> via the architecture specific includes.
>
I missed about S3C2443.
Yes, but I think including architecture specific header files is valid
only in case that all the S3C64XX registers are same with S5PC100.
Actually, almost registers of S5PC100 are same with S3C64XX but
different from some registers as I said before.
If new features for S5PC100 would be added to your driver then we
would find #ifdef CONFIG_S5PC100 in your driver.
this reason is because your driver calls low level functions (writel and readl).
So considering S5PC100 and S5PC110, I think it is good way to call
only generic interfaces.

for example,
s3c_fb_enable() calls low level function (writel) for enabling LCD Controller.
but my proposal will call generic interface in specific file. like
this fb_enable() -> s3c_fb_enable().
fb_enable(), as generic interface, will call s3c_fb_enable() and
s3c_fb_enable() is specific code (writel and readl are used here).

In case of this, s3c-fb.c, as generic driver, could support S3C2442,
S3C64XX, S5PC100 and S5PC110.
So I would like to divide Samsung SoC Framebuffer Driver into generic
driver and specific driver.

How do you think about that and do you have any idea ?

>> How do you think about that ?
>>
>> 2.
>> S3C64XX LCD Controller's registers are similar with S5PC100's, so I
>> wouldn't modify register prefix.
>> but some registers should added to definition file
>> (arch/arm/mach-s3c6400/include/mach/regs-fb.h).
>
> I don't have documentation for any of these newer chips, so cannot make
> much of a comment without any more detailed data.
>
>> which way do you prefer adding some registers to
>> arch/arm/mach-s3c6400/include/mach/regs-fb.h or creating new
>> definition file for S5PC100 ?
>>
>> If you give me your comments for the issues above, I will modify
>> Samsung SoC Framebuffer Driver to be supported for S3C64XX and
>> S5PC100.
>> In the result, I expect that your driver will be divided into logical
>> driver and specific driver supporting S3C64XX and S5PC100 or either
>> S3C64XX or S5PC100.
>> If the driver would be completed, logical driver, s3c-fb.c, would
>> support S3C64XX, S5PC100 and also S5PC110.
>
> I'll let you have a think about this wrt to the answer supplied for #1,
> and see if you need any further information about it after that.
>
>> Please give me your comments and advices.
>>
>> Best Regards,
>> InKi Dae.
>
>
> --
> Ben Dooks, Software Engineer, Simtec Electronics
>
> http://www.simtec.co.uk/
>
