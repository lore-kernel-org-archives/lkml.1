Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZEANYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZEANYb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZEANYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:24:22 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50797 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZEANYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <20090501141846.4b833700@lxorguk.ukuu.org.uk>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk> 
	<ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com> 
	<20090501141846.4b833700@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 15:24:01 +0200
Message-ID: <ac3eb2510905010624k891f680s7255af8ae185b5d5@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 15:18, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> No tool ever has a chance to get to the information only available at
>> early kernel init. All such tools will need to "replay" what the
>> kernel already did. This is intended to save us from doing this, and
>> retain the information which is there, but lost at the moment the
>> tools have the first chance to run.
>
> Serious question - which is the better problem to fix ?

I'm very sure, you can not fix it outside the kernel. Or do you have
an idea how to create the missing device nodes for device without
crawling sysfs, when the first userspace process is started?

>> It's not about a sucking tool, its just impossible. And there is no
>> space wasted, it's a single string for a very few subsystems, an
>> nothing is stored per device.
>
> Plus code plus tmpfs nodes (the latter are not quite free because you
> create unneeded ones versus udev but I agree that is noise for most users)

It's exactly the same as udev. Udev creates a node for every device
the core registers in tmpfs. This tmpfs is mounted by the kernel and
pre-populated with this, not by udev, that's all the difference it
has. There is not a single node more than before.

Thanks,
Kay
