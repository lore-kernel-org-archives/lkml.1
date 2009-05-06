Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZEFQLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZEFQLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZEFQLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:11:23 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38508 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZEFQLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=il3qrPslQhGU1YIRQqTii374H4ySwJcZQCCtvrCSmJj5e/ETQPkWzq6rUw7o3iLJDd
         rGs9xQDJC8YrSm9Uf0Gi5akpFtsvHx4GnGTX+rb2ZJ2WISsGiP7OKUTG+4eugaFP2iuc
         QV1IB5Wxy58jhVzb5meNqs7uuwK78fY4DQRDQ=
Date: Wed, 6 May 2009 18:11:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk %0*X is broken.
Message-ID: <20090506161116.GA5997@nowhere>
References: <4A0136F4.4010504@kernel.org> <20090506071839.GA14412@elte.hu> <4A014A9D.8000903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A014A9D.8000903@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 04:30:21PM +0800, Li Zefan wrote:
> Ingo Molnar wrote:
> > Cc:-ed more folks who modified lib/vsprintf.c recently.
> > 
> > 	Ingo
> > 
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> it seems someone broke 
> >>
> >> printk(   "%0*X\n", width, x);
> >>
> >> looks like 0 is dumped.
> >>
> >> YH
> >>
> >> [    0.000000] MTRR variable ranges enabled:
> >> [    0.000000]   0 base 0   00000000 mask FF0 00000000 write-back
> >> [    0.000000]   1 base 10  00000000 mask FFF 80000000 write-back
> >> [    0.000000]   2 base 0   80000000 mask FFF 80000000 uncachable
> >> [    0.000000]   3 base 0   7F800000 mask FFF FF800000 uncachable
> >>
> 
> 2.6.30-rc4-tip, the output of my box:
> 
> high_width: 1
> MTRR variable ranges enabled:
>   0 base 000000000 mask FC0000000 write-back
>   1 base 03C000000 mask FFC000000 uncachable
>   2 base 0D0000000 mask FF8000000 write-combining
> 
> Is it possible that high_width is negative in your output?
> If high_width == -3, we can get exactly the same output with yours.


Indeed, a negative value given as the width will actually pad to the
right (reverse width forcing).
If you have -3, that matches the normal printf behaviour.

Yinghai, could you check please if that's the case for you? 

Thanks,

Frederic.

