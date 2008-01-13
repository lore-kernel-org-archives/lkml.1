Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYAMNK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYAMNK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 08:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYAMNKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 08:10:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:6029 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYAMNKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 08:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TKw4Umj4JWQxYjHrYU+eW0j02IqUviBLwEKyifhSuYQbxavUQkaejtmUwvas1XkYPKzpUGy/kXgyw+5gsvw3ebIbcK0GmeNXg5lhEMvrA34wnMI45o8C8pqHdoE/t3LJ1vVAvY9LWo3dKIluLnd2F70rqKYeeobDQ9+LNOyzznU=
Message-ID: <76366b180801130510w2af714fevf03f59164f90806f@mail.gmail.com>
Date: Sun, 13 Jan 2008 08:10:46 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
Cc: linux-kernel@vger.kernel.org, "Balaji Rao" <balajirrao@gmail.com>
In-Reply-To: <20080113120337.GA5548@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
	 <20080113120337.GA5548@linux.vnet.ibm.com>
X-Google-Sender-Auth: 51423d4f072e406d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied the patch to my 2.6.23.13 tree and upon reboot it stopped right after:

Clocksource tsc unstable (delta = ... ns)
Time: hpet clocksource has been installed.

It locked up hard.. cursor stopped blinking and SysRq isn't working either.

-Andrew

On Jan 13, 2008 7:03 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>
> On Sun, Jan 13, 2008 at 06:10:52AM -0500, Andrew Paprocki wrote:
> > I started debugging a problem I was having with my sky2 network driver
> > under 2.6.23.13. The investigation led me to find that the HPET timer
> > wasn't working at all, causing the sky2 driver to not work properly.
> > Simple example:
> >
> > am2:/sys/devices/system/clocksource/clocksource0# cat current_clocksource
> > jiffies
> > am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> > real    0m1.000s
> > user    0m0.000s
> > sys     0m0.000s
> > am2:/sys/devices/system/clocksource/clocksource0# echo tsc > current_clocksource
> > am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> > real    0m1.005s
> > user    0m0.004s
> > sys     0m0.000s
> > am2:/sys/devices/system/clocksource/clocksource0# echo hpet >
> > current_clocksource
> > am2:/sys/devices/system/clocksource/clocksource0# time sleep 1
> > <hangs indefinetly...>
> >
> > Running strace shows it blocked on nanosleep(). I'm building the
> > kernel with the processor type set to Athalon64. I've built it with
> > and without SMP and high-res timers enabled and I get the same result.
> > My previous 2.6.18-4 kernel works because it does not install HPET as
> > the default timer. The same behavior occurs in 2.6.24-rc7 git head.
> > I've attached the config/dmesg below.
> >
>
> It seems the HPET timer was not being assigned any IRQs at all. Can you
> try the patch at http://lkml.org/lkml/2008/1/12/128 ?
>
> Thanks,
> --
> regards,
> Dhaval
>
>
