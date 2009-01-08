Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZAHD6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZAHD6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZAHD6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:58:15 -0500
Received: from mail2.ntp.org ([204.152.184.138]:51231 "EHLO mail2.ntp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbZAHD6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:58:11 -0500
Message-ID: <496579C2.5050800@ntp.isc.org>
Date: Wed, 07 Jan 2009 22:57:54 -0500
From: Danny Mayer <mayer@ntp.isc.org>
Reply-To: mayer@ntp.isc.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "M. Warner Losh" <imp@bsdimp.com>, linasvepstas@gmail.com, david@lang.hm,
       hancockr@shaw.ca, kyle@moffetthome.net, slashdot@jameshallam.info,
       goodgerster@gmail.com, davidn@davidnewall.com,
       linux-kernel@vger.kernel.org, ntpwg@lists.ntp.isc.org,
       pretzalz@techhouse.org, burdell@iruntheinter.net, nick@nick-andrew.net,
       jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
References: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>	<3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>	<49642674.9080703@ntp.isc.org>	<20090107.103947.1324582654.imp@bsdimp.com> <20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-kostecke.net-MailScanner: Found to be clean
X-kostecke.net-MailScanner-From: mayer@ntp.isc.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> time, causing time to jump backwards by 1s (or violate POSIX time_t's
>> invariant that midnight time_t is % 86400 == 0).  This jump backwards
>> is a pita in the kernel, and violates the assumption that many
>> programs have that time doesn't flow backwards.
> 
> They can slew the clock slowly as well. There is a wonderful quote from
> one of the summaries of the POSIX committee discussions on time that says
> quite simply "the posix clock is not guaranteed to be accurate"
> 
> As it currently stands the kernel contains sufficient support that at the
> point you know a leap second is coming you can adjust the second length
> marginally over the entire period.
> 
> The current behaviour is an implementation decision. Jumping on a second
> shouldn't be an issue to most people, jumping back is asking for badness
> but isn't in fact used in the world today. Slewing the entire day so that
> each second is 1/86400 of a second longer or shorter wouldn't be noticed
> by anyone.

NTP handles most of this, but it needs the cooperation of the O/S kernel
and most of the Unix kernels are able to provide the required API's.
FreeBSD doesn't have any of these problems but Linux historically has.
Most of that code was designed by Dave Mills but since each kernel is
different we should not expect them all to behave the same way and
generally requires an understanding of what NTP expects and that's not
always clear to kernel developers who are not expected to know NTP.

Danny
