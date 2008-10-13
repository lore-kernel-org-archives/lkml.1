Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbYJMKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbYJMKLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbYJMJvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:51:21 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47537 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbYJMJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:51:20 -0400
Date: Mon, 13 Oct 2008 12:50:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Neshama Parhoti <pneshama@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: section mismatch with a platform driver
Message-ID: <20081013095018.GC29938@cs181140183.pp.htv.fi>
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com> <20081013085111.GB29938@cs181140183.pp.htv.fi> <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 11:28:23AM +0200, Neshama Parhoti wrote:
> Hi Adrian and thank you for the help!
> 
> On Mon, Oct 13, 2008 at 10:51 AM, Adrian Bunk <bunk@kernel.org> wrote:
> > On Mon, Oct 13, 2008 at 10:19:05AM +0200, Neshama Parhoti wrote:
> >> WARNING: vmlinux.o(.data+0x44bc4): Section mismatch: reference to
> >> .init.text:my_probe_func (between 'my_platform_struct' and
> >> 'debug_level_variable')
> >>
> >> If I understand correctly, it shouts about my probe function being
> >> referenced from the data section:
> >>
> >> static struct platform_driver my_platform_struct = {
> >>       .probe          = my_probe_func,
                                     ^^^^^

Ah, you had your example wrong and silently edited your quoted email.

> >>       .remove         = my_remove,
> >>       .suspend        = my_suspend,
> >>       .resume         = my_resume,
> >>       .driver         = {
> >>               .name = DRIVER_NAME,
> >>       },
> >> };
> >>
> > It complains about "my_probe_func", and that's not even in the code
> > you posted.
> 
> It happens even if I use an empty function like this:
> 
> static int __init my_probe_func(struct platform_device *pdev)
> {
> 	return 0;
> }
> 
> any idea what's the problem ?

The function has a wrong name.

> thanks again!
> pnesh

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

