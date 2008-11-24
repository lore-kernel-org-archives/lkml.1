Return-Path: <linux-kernel-owner+w=401wt.eu-S1752189AbYKXFIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbYKXFIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750719AbYKXFII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:08:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:2690 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYKXFIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:08:07 -0500
Message-ID: <cfec22b10811232108u3ade8b66w58999054c03549fc@mail.gmail.com>
Date: Sun, 23 Nov 2008 21:08:05 -0800
From: "John McCutchan" <john@johnmccutchan.com>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: [take 3] Use pid in inotify events.
Cc: "Arnd Bergmann" <arnd@arndb.de>, mtk.manpages@gmail.com,
       "Christoph Hellwig" <hch@lst.de>, "Robert Love" <rlove@rlove.org>,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081122093749.GA12543@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com>
	 <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de>
	 <20081122093749.GA12543@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point I don't really want to see changes made to inotify. But,
for arguments sake, why not something like inotify_init1 that takes a
flag EXTENDED_EVENT which causes a larger event structure to be used.
Something like,

struct inotify_event_extended
{
  s32 wd;
  u32 mask;
  u32 cookie;
  u32 data[4];
  char path[0];
}

The data array could be used to store arbitrary extra information,
specified by flags.

On Sat, Nov 22, 2008 at 1:37 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Fri, Nov 21, 2008 at 07:39:45PM +0100, Arnd Bergmann (arnd@arndb.de) wrote:
>> The how about an inotify_init1 flag telling the kernel to ignore
>> changes done by the current PID? That sounds like it is potentially
>> useful to other applications that want to monitor the whole file system
>> and also write to it. It also doesn't need to change the ABI in
>> incompatible ways or introduce a security relevant side channel.
>
> That's a good idea. Robert, John, Michael - comments?
>
> --
>        Evgeniy Polyakov
>



-- 
John McCutchan <john@johnmccutchan.com>
