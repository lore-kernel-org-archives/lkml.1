Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZFSNg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZFSNg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZFSNgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:36:50 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:36111 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZFSNgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DRJGIsWEmUl7eTJKMJbHkEgLIVcK01zTmkcqmQgxFNQp1mgsQ2V4IVAj+WIrCldQ6Y
         q0QaixGNszlA1763ScBVwkO8GAgEkVAP5KoisN78FBhtUQ1L2B5M7V3b2yB7Aa+XDPiO
         fS+T7/2aKkG5iGblHX9DpDBb38zixylDbRY38=
MIME-Version: 1.0
In-Reply-To: <4A3B9219.3020803@hp.com>
References: <87a5b0800906190415o1c70b6basfde98269dbacd00e@mail.gmail.com>
	 <4A3B9219.3020803@hp.com>
Date: Fri, 19 Jun 2009 14:36:50 +0100
Message-ID: <87a5b0800906190636j227fb778va3b3e0792680cdd3@mail.gmail.com>
Subject: Re: Mounting sysfs early
From: Will Newton <will.newton@gmail.com>
To: jim owens <jowens@hp.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 2:26 PM, jim owens<jowens@hp.com> wrote:
> Will Newton wrote:
>>
>> Hi all,
>>
>> I currently have a problem with a driver that loads firmware from
>> userland. The boot process happens in this order:
>>
>> 1. Extract initramfs
>> 2. Load drivers
>> 3. Run init
>>
>> Unfortunately it appears that step 2 is calling the hotplug helper
>> which tries to load firmware via sysfs, but sysfs is not mounted until
>> I have run init so the driver fails to initialise. What is the
>> recommended way to avoid this situation? Do I have to somehow build
>> the firmware into the kernel or can I get sysfs mounted before drivers
>> begin loading?
>
> you did not say what distro and kernel, but I would expect
> sysfs is mounted before step 2 by the intrd.  this is what I
> see in a rhel 4.3 I am testing.

I'm on an embedded board with kernel 2.6.30 booting with only an
initramfs. I should have been clearer by load drivers I mean run the
device initcalls, for example the rootfs is unpacked at initcall level
"rootfs", which is followed by device initcalls at level 6, which is
followed later by init being run. It's at this last stage that I get
sysfs mounted, which is too late, I'd like it mounted in time for
running initcall level 6. Is this possible?

> what you might be really seeing is
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13178
>
> which I am currently debugging.

I don't think it's the same issue. I actually have no sysfs mounted on
/sys, it's empty.
