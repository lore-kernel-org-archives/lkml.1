Return-Path: <linux-kernel-owner+w=401wt.eu-S1423130AbXBUVQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423130AbXBUVQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423132AbXBUVQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:16:31 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1936 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423125AbXBUVQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:16:29 -0500
X-AuthUser: hirofumi@parknet.jp
To: Greg KH <greg@kroah.com>
Cc: "YOSHIFUJI Hideaki \/ \?$B5HF#1QL\@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: request_module: runaway loop modprobe net-pf-1 (is Re: Linux 2.6.21-rc1)
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	<20070222.012356.27907445.yoshfuji@linux-ipv6.org>
	<87ps8372bf.fsf@duaron.myhome.or.jp>
	<20070221203652.GB17830@kroah.com>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Thu, 22 Feb 2007 06:16:23 +0900
In-Reply-To: <20070221203652.GB17830@kroah.com> (Greg KH's message of "Wed\, 21 Feb 2007 12\:36\:52 -0800")
Message-ID: <87abz75hzs.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Thu, Feb 22, 2007 at 04:12:04AM +0900, OGAWA Hirofumi wrote:
>> YOSHIFUJI Hideaki / ?$B5HF#1QL@ <yoshfuji@linux-ipv6.org> writes:
>> 
>> > In article <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> (at Tue, 20 Feb 2007 20:53:45 -0800 (PST)), Linus Torvalds <torvalds@linux-foundation.org> says:
>> >
>> >> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
>> >> name it), ACPI updates, and lots of driver work. And just a lot of 
>> >> cleanups.
>> >
>> > I cannot boot 2.6.21-rc1; it falls into OOM-Killer.
>> >
>> > Interesting error message I can see is:
>> >    request_module: runaway loop modprobe net-pf-1
>> >
>> > After bisecting, the commit
>> >   Driver core: let request_module() send a /sys/modules/kmod/-uevent
>> > (id c353c3fb0700a3c17ea2b0237710a184232ccd7f) is to blame.
>> >
>> > Reverting it fixes the issue to me.
>> 
>> /sbin/hotplug needs some module, but request_module() call /sbin/hotplug loop?
>> Hm.. does the patch fix the problem?
>
> How does it loop?

E.g. something calls the request_modle(), and if hotplug is using
socket(PF_UNIX) and af_unix is module, it also calls request_modle()?

Just my guess though...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
