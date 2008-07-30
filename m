Return-Path: <linux-kernel-owner+w=401wt.eu-S1761926AbYG3J5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761926AbYG3J5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 05:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbYG3J5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 05:57:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:51261 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761865AbYG3J5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 05:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tjLo8ERMhu8iREjkZioVzP8CIExnWgD9Cqv9K25X2n2Ab5hdR1fvjCpMq+lO16CtFe
         3s4NxkUpbk2D0e7CxLI8mDmBQF+kBeNVc9Kmt9S9wqY2Zs9i+6vhPk1Hfpole/ymlG2t
         jfOpdxLmDeucREtrswKKehV24HhG8Gd0dJW8c=
Message-ID: <b647ffbd0807300257x43dd6018o59533bec11b7a504@mail.gmail.com>
Date: Wed, 30 Jul 2008 11:57:18 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
Cc: "Max Krasnyansky" <maxk@qualcomm.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48903431.9060707@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729154103.007575982@amd.com>
	 <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
	 <488F581B.7060009@qualcomm.com> <48903431.9060707@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/30 Peter Oruba <peter.oruba@amd.com>:
>> [ ... ]
>
> Since ucode updates may fix severe issues, it is supposed to happen as early
> as possible. If you re-plug your CPU into your socket, your BIOS also
> applies a ucode patch, but that won't necessarily be the latest and critical
> one.

Hum, let's say we don't do it from cpu-hotplug handlers [1] but from
start_secondary() before calling cpu_idle()? [*]

This way, we do it before any other task may have a chance to run on a
cpu which is not a case with cpu-hotplug handlers
(and we don't mess-up with cpu-hotplug events :-)

[ the drawback is that 'microcode' subsystem is not local to
microcode.c anymore ]

[1] if we need a sync. operation in cpu-hotplug handlers and IPI is
not ok (say, we need to run in a sleepablel context) then perhaps it's
workqueues + wait_on_cpu_work(). But then it's not a bit later than
could have been with [*].

heh, this issue has already popped up in another thread so it should
be fixed asap, imho.

Ingo, Peter? What would be the best way from your pov?


>
> Peter
>

-- 
Best regards,
Dmitry Adamushko
