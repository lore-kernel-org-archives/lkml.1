Return-Path: <linux-kernel-owner+w=401wt.eu-S1758853AbYJMQCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbYJMQCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYJMQBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:01:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52872 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbYJMQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:01:54 -0400
Date: Mon, 13 Oct 2008 09:01:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Neshama Parhoti" <pneshama@gmail.com>
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: section mismatch with a platform driver
Message-Id: <20081013090133.a58116a2.randy.dunlap@oracle.com>
In-Reply-To: <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	<20081013085111.GB29938@cs181140183.pp.htv.fi>
	<912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 11:28:23 +0200 Neshama Parhoti wrote:

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
> 
> any idea what's the problem ?

A probe function can be called at any time -- i.e., after system init
has completed, so discarding the __init function my_probe_func() is BAD,
dangerous, BUGgy.

---
~Randy
