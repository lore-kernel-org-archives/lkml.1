Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXKDXI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXKDXI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXKDXIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:08:20 -0500
Received: from gw.goop.org ([64.81.55.164]:40403 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbXKDXIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:08:19 -0500
Message-ID: <472E50C5.5020201@goop.org>
Date: Sun, 04 Nov 2007 15:07:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se>
In-Reply-To: <200711042158.lA4Lwv9S014628@harpo.it.uu.se>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> On Sun, 04 Nov 2007 11:41:58 -0800, H. Peter Anvin wrote:
>   
>> Mikael Pettersson wrote:
>>     
>>> First patch didn't build. Second patch builds and boots Ok.
>>>
>>> So this means the 486 DX4 has a buggy mov to %cr0?
>>>
>>>       
>> Apparently.
>>     
>
> Maybe not. I had a look in Intel's SDM Vol3, and the
> section "switching to protected mode" specifies that
> a move to %cr0 that sets PE should immediately be
> followed by a far jmp or call.
>   

Yes, that's what the spec says.  I queried this a few months ago, but
hpa used his convincing voice and said that in practice it isn't
necessary; there are no known cpus which need this, and any that do
would cause other things to break.  But I guess now we have the
counter-example...

    J
