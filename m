Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZGASkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZGASkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZGASju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:39:50 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45084 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZGASjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ksaYqAOgrFSbZC5sn9tNqQfAzk1DYxT3QsuQdavIA4GkMl2m0o/vsfd7lZTPbXhvaV
         HA9jS45+o9COfzp4sHbFgwIctPj1uNvmvMF4pPB/BxvFsI8LKlmaD56hoC02thbx3TT4
         tyDSIUmx8KeGVxesHE8tu3byx3+ro8g/4QlS8=
Message-ID: <4A4BAD5F.7050908@gmail.com>
Date: Wed, 01 Jul 2009 20:39:27 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly caused
    by netem)
References: <4A4A9DD6.8060800@anarazel.de>
In-Reply-To: <4A4A9DD6.8060800@anarazel.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Freund wrote, On 07/01/2009 01:20 AM:

> Hi,

Hi,

> 
> While playing around with netem (time, not packet count based loss-
> bursts) I experienced soft lockups several times - to exclude it was my
> modifications causing this I recompiled with the original and it is
> still locking up.
> I captured several of those traces via the thankfully
> still working netconsole.
> The simplest policy I could reproduce the error with was:
> tc qdisc add dev eth0 root handle 1: netem delay 10ms loss 0
> 
> I could not reproduce the error without delay - but that may only be a
> timing issue, as the host I was mainly transferring data to was on a
> local network.
> I could not reproduce the issue on lo.
> 
> The time to reproduce the error varied from seconds after executing tc 
> to several minutes.
> 
> Traces 5+6 are made with vanilla 52989765629e7d182b4f146050ebba0abf2cb0b7
> 
> The earlier traces are made with parts of my patches applied, and only 
> included for completeness as I don't believe my modifications were 
> causing this and all traces are different, so it may give some clues.
> 
> Lockdep was enabled but did not diagnose anything relevant (one dvb 
> warning during bootup).
> 
> Any ideas for debugging?

Maybe these traces will be enough, but lockdep report could save time.
If dvb warning triggers every time then lockdep probably turns off
just after (it works this way, unless something was changed). So,
could you try to repeat this without dvb? Btw., did you try this on
some earlier kernel?

Thanks,
Jarek P.
