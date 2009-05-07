Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZEGClA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZEGClA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbZEGCkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:40:49 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:40346 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZEGCks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <20090506192538.4966c283@infradead.org>
References: <1241097822.2516.3.camel@poy> <20090506184122.721c890d@infradead.org> 
	<ac3eb2510905061908u7acbd1b2nf991aa85e1517fe4@mail.gmail.com> 
	<20090506192538.4966c283@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 7 May 2009 04:40:29 +0200
Message-ID: <ac3eb2510905061940u9f90962uc78f4391794ae031@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 04:25, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 7 May 2009 04:08:33 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>> How will you solve the dynamic device numbers? They are a complete
>> reality today.
>
> not for storage though...

Oh sure:
  cat /sys/class/block/sd*/dev
  259:524288
  259:262144
  259:786432
  259:131072
  259:0
  259:393216
  259:655360

That's the box I write this from. It's experimental now but in the
upstream kernel. Distros want to support more than 15 partitions, so
that will happen sooner than later.

And you may talk to the wrong rtc device, if you use static nodes, and
so on. There are just too many things that can go wrong, and distros
that don't have a very limited set of hardware, can not take the risk
of a static /dev. They don't have this today, and will not go back to
it. That's why we are coming up with this.

> and for the rest udev is fast enough in
> practice....

Sure, but you still have the transition to the tmpfs /dev, and during
that you are very limited in what you can do, and this addresses
devtmpfs.

Thanks,
Kay
