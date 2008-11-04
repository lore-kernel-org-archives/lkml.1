Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYKDUCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYKDUCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:02:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYKDUCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:02:39 -0500
Received: from gw.goop.org ([64.81.55.164]:39470 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYKDUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:02:38 -0500
Message-ID: <4910AA51.3070602@goop.org>
Date: Tue, 04 Nov 2008 12:02:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Mike Travis <travis@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com> <20081104124242.GA6795@elte.hu> <1225805399.25337.1282903253@webmail.messagingengine.com> <20081104140030.GA16178@elte.hu>
In-Reply-To: <20081104140030.GA16178@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ( another advantage is that the 6 bytes GDT descriptor is more 
>   compressed and hence uses up less L1/L2 cache footprint than the 
>   larger (~7 byte) trampolines we have at the moment. )
>   

Also its D cache rather than I cache, which is generally more 
plentiful.  However, I think the cost of GDT cache misses on exception 
latency is something that we've largely overlooked, and this will make 
it a bigger factor (vs cache misses on the actual exception handler code 
itself, which should be reduced).

    J
