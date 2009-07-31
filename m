Return-Path: <linux-kernel-owner+w=401wt.eu-S1751665AbZGaXbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbZGaXbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 19:31:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZGaXbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 19:31:04 -0400
Received: from are.twiddle.net ([75.149.56.221]:47994 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbZGaXbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 19:31:04 -0400
Message-ID: <4A737EB1.1000602@twiddle.net>
Date: Fri, 31 Jul 2009 16:30:57 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: use .data.init_task instead of .data.init_thread.
References: <1249073786-29788-1-git-send-email-tabbott@ksplice.com> <4A7360C3.2060507@twiddle.net> <alpine.DEB.1.10.0907311739040.2539@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.10.0907311739040.2539@vinegar-pot.mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2009 03:02 PM, Tim Abbott wrote:
> The INIT_TASK_DATA(THREAD_SIZE) macro call aligns to THREAD_SIZE (=
> 2*PAGE_SIZE).  So I'm not removing the 2 page alignment; I'm just moving
> it along with the code that needs to be aligned.

Sure.

>
> This change:
>
> -	. = ALIGN(2 * PAGE_SIZE);
> +	. = ALIGN(PAGE_SIZE);
>   	__init_end = .;
>
> removes the now-unnecessary (2 * PAGE_SIZE) alignment for __init_end
> caused by moving .data.init_task (it should have been in the first patch).

While it's technically unnecessary, it's also very much desired.

Think about it.  Suppose we have 9 pages of init, followed by the
two-page-aligned INIT_TASK_DATA.  So we get a page worth of padding
added.  It's better to have the two-page-alignment within the init
section so as to get 10 pages of init followed by no padding.  In
this way the page of padding gets freed with the rest of init.

Are you following me at all here?


r~
