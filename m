Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0BTHcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:32:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0BTHca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:32:30 -0500
Message-ID: <4B7F90AA.8050306@redhat.com>
Date: Sat, 20 Feb 2010 15:35:06 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Hui Zhu <teawater@gmail.com>,
       =?ISO-8859-1?Q?Ozan_=C3aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: improve checkstack
References: <20100219175217.385580142@vyatta.com>	<20100219175429.611463369@vyatta.com>	<4B7F5128.70501@redhat.com> <20100219222554.17d4bae6@nehalam>
In-Reply-To: <20100219222554.17d4bae6@nehalam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> Turn on strict checking, and get rid of annoying use of prototype.
> Fix syntax error in declaration
> 
> Use efficient sort algorithm by using schwartzian transform.
>   http://en.wikipedia.org/wiki/Schwartzian_transform


Yeah, the idea is good, this can also make it more perlish. ;)

But...


> -print sort bysize @stack;
> +# Use Schwartzian transform to sort by last field (size)
> +print map { $_->[0] }
> +      sort { $b->[1] <=> $a->[1] }
> +      map { [$_, /:\t*(\d+)$/] } @stack;

This regex here is not strictly the same as before.

Can we just keep the original regex? If not, what's wrong?

Thanks.
