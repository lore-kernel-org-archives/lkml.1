Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab0BPUIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 15:08:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55623 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665Ab0BPUIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:08:19 -0500
To: Octavian Purdila <opurdila@ixiacom.com>
Cc: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Amerigo Wang <amwang@redhat.com>
Subject: Re: [net-next PATCH v4 0/3] net: reserve ports for applications using fixed port
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>
	<201002162004.33533.opurdila@ixiacom.com>
	<m17hqd583i.fsf@fess.ebiederm.org>
	<201002162151.04861.opurdila@ixiacom.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 16 Feb 2010 12:08:13 -0800
In-Reply-To: <201002162151.04861.opurdila@ixiacom.com> (Octavian Purdila's message of "Tue\, 16 Feb 2010 21\:51\:04 +0200")
Message-ID: <m1mxz93pw2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila <opurdila@ixiacom.com> writes:

> On Tuesday 16 February 2010 20:49:37 you wrote:
>
>> > The use case (large bitmaps/lists) is different enough from what we have
>> > today  (small bitmaps) and that is why I think that we need this new
>> > interface.
>> >
>> > If I get bitmap_parse_user correctly, for a 64k bitmap it expects a 2K
>> > comma  separated values. That is not the most intuitively way for the
>> > user to set a list of ports he wants to reserve.
>> 
>> In this case I expect an interface of comma separated ranges would be
>> ideal.  Typically compact, and modifiable by writing the new value to
>> the file.
>> 
>
> Something like bellow?
>
> # set bits 8080 and 1666 
> $echo 8080 1666-1666 > /proc
>
> #reset bit 1666
> $echo 8080 > /proc
>
> #reset whole bitmap
> $echo > /proc

Yes. So something like that.

I think I would use commas instead of spaces as that is more traditional.

>> I think the default value would be something like 32768-61000.
>
> Note that this new proc entry will work in conjunction with the existing 
> ip_local_port_range option, so the default bitmap can (and should be) empty.

Do we want userspace to see this implementation detail? Two data structures doing
the almost the same thing could get confusing in a hurry.  It feels like
a recipe for changing one and not the other and then running around trying to
figure out why the change did not work.

Eric

