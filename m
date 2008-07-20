Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYGTXMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYGTXMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 19:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbYGTXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 19:12:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:38832 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYGTXMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 19:12:16 -0400
Date: Sun, 20 Jul 2008 16:12:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Neil Brown <neilb@suse.de>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Simon Arlott <simon@fire.lp0.eu>,
       Daniel Walker <dwalker@mvista.com>,
       Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 3/4] fastboot: make the raid autodetect code wait for
 all devices to init
In-Reply-To: <18563.50428.659101.868745@notabene.brown>
Message-ID: <alpine.DEB.1.10.0807201610410.32536@asgard.lang.hm>
References: <20080720151140.4aa7c682@infradead.org> <20080720151339.6f4a83d8@infradead.org> <18563.50428.659101.868745@notabene.brown>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Neil Brown wrote:

> I must say that I think this is pretty horrible.   But then it is a
> pretty horrible problem and I don't think there is a clean solution.
>
> If md in a module, this code won't run so there will be no change.  If
> md is compiled in, this code will silently slow down boot even if
> there are no raid arrays to assemble.  I think the "silently" is a
> problem.  I'm not looking forward to "my computer boots slower if I
> compile md into the kernel" reports on linux-raid@vger.
>
> What would you think of
>
>    if (driver_probe_done() != 0) {
> 	printk("md: Waiting for all devices to be available before autodetect\n"
>               "md:  If you don't boot off raid, use raid=noautodetect\n");
>        do
>           msleep(100);
> 	while (driver_probe_done() != 0);
>    }
>
> ??

even if you don't boot off of raid, if the boot process will mount a raid 
that's autodetected this will be a problem. so I think the message needs 
to allow for this.

David Lang

