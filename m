Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZEALMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZEALMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZEALL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:11:58 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49591 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbZEALL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <20090501120359.05bacb48@lxorguk.ukuu.org.uk>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <20090501120359.05bacb48@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 13:11:36 +0200
Message-ID: <ac3eb2510905010411r2c1a2be5s449aaf485a76a8c4@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 13:03, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Boot speed, boot speed, boot speed.
>>
>> Oh, and reduction in complexity in init scripts, and saving embedded
>> systems a lot of effort to implement a dynamic /dev properly (have you
>> _seen_ what Android does to keep from having to ship udev?  It's
>> horrible...)
>
> This is nothing to do with udev or the kernel side of things. Your
> argument seems to be
>
> "Remove a user space problem and make it a kernel one stuffed in
>  unpageable RAM and less flexible"
>
> It seems to me your actual problem is "my tools suck" and the fix for
> that is to fix the tools not add more random kernel junk.

The problem is that people optimize for fractions of seconds today,
driven mainly by your company. :)

No tool ever has a chance to get to the information only available at
early kernel init. All such tools will need to "replay" what the
kernel already did. This is intended to save us from doing this, and
retain the information which is there, but lost at the moment the
tools have the first chance to run.

It's not about a sucking tool, its just impossible. And there is no
space wasted, it's a single string for a very few subsystems, an
nothing is stored per device.

Thanks,
Kay
