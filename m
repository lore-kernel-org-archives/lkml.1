Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYAWPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYAWPhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYAWPhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:37:31 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:11230 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYAWPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=wQ4QO1w3W5xHmoxkzF7EDkYRGhKKccU4UezJCaQo6ysS+VyZvIW+MJqjGObx+V3qZSiH4+DPZRh+GKjdPWkxiRz4lraqzGXP/tKnRDtBfzzKcCtvtEhJ5ygz0pAaYdd/9qyxJRAAhVzDfC2aTzrSJzja3eWyUZwblm1jKuiPVSg=
Message-ID: <47975F33.6040206@gmail.com>
Date: Wed, 23 Jan 2008 16:37:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Oyvind Aabling <Oyvind.Aabling@uni-c.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/moxa.c, kernel 2.6.23.14
References: <Pine.LNX.4.64.0801202145230.18101@dbs1.uni-c.dtu.dk> <479521F7.9050701@gmail.com> <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk>
In-Reply-To: <Pine.LNX.4.64.0801221042270.19094@dbs1.uni-c.dtu.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2008 11:23 AM, Oyvind Aabling wrote:
> On Mon, 21 Jan 2008, Jiri Slaby wrote:
>> Would you be willing to test such a patch for point no. 3?
> 
> Yes, I could do that.
> 
> I can see your point about the non-portability of it, but
> how about this scenario, to provide backwards compatibility:
> 
> * We keep the (ugly and non-compatible) MOXA_GET_CONF
>   ioctl, to avoid breaking the old moxaload.
>   Let's rename it to MOXA_GET_CONF_OLD or MOXA_GET_CONF_BAD in the driver.
> * Create a new MOXA_GET_CONF ioctl (with a new
>   number, of course), that does it "the right way".
>   If you don't like renaming ioctl's, we need a new name for this one.
> * Rewrite moxaload to either do a kernel version check
>   and use the new ioctl if available or the old if not.
>   Or skip that and let it call the new ioctl first.
>   If it succeeds (system running a newer kernel): fine, and
>   if not (system running an older kernel), use the old ioctl.
> 
> The MOXA Intellio driver and moxaload have been "broken" ever since they
> were written in 1999, and this way, we don't break anything - you can
> use old or new kernel, and old or new moxaload in any combination.
> 
> Whaddaya think ?

We won't need anything from that. I'm almost done with firmware support. The 
only thing you'll need to do is to copy the .cod file(s) into /lib/firmware or 
wherever your firmware loader (probably udev nowadays) finds such files.

Could you post me lspci -vvxxx output of your moxa card?

thanks,
--js
