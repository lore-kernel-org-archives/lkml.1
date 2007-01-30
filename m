Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXA3Fky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXA3Fky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 00:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965410AbXA3Fky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 00:40:54 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:18830 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXA3Fky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 00:40:54 -0500
To: schwidefsky@de.ibm.com
Cc: Andrew Morton <akpm@osdl.org>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, dmonakhov@openvz.org
Subject: Re: + mm-search_binary_handler-mem-limit-fix.patch added to -mm tree
References: <200701240909.l0O99IwK013495@shell0.pdx.osdl.net>
	<20070129113328.GA9941@osiris.boeblingen.de.ibm.com>
	<20070129135958.GB9941@osiris.boeblingen.de.ibm.com>
	<20070129093751.a1637a68.akpm@osdl.org>
	<1170094705.17738.11.camel@localhost>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Tue, 30 Jan 2007 08:40:59 +0300
In-Reply-To: <1170094705.17738.11.camel@localhost> (Martin Schwidefsky's message of "Mon, 29 Jan 2007 19:18:25 +0100")
Message-ID: <87veipxeac.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The function changes mem limit to USER_DS before possible modprobe, but
> > > never restored it again.
Truly. The road to hell is paved with good intentions.

Martin Schwidefsky <schwidefsky@de.ibm.com> writes:
> On Mon, 2007-01-29 at 09:37 -0800, Andrew Morton wrote:
>> hm, thanks for testing - I'll drop it.
>> 
>> I don't really understand what's wrong with it though.  Maybe it's settng
>> USER_DS on kernel threads?
>
> For architectures with a split address space there has to be a call
> set_fs(USER_DS) that switches from KERNEL_DS to USER_DS for the init
> process. So far this has been done in search_binary_handler and
> traditionally the kernel starts with KERNEL_DS to make the early
> copy_from_user calls work.
> So, what is wrong with always setting USER_DS? We are starting a user
> space process after all.
May be add some comment to prevent future attempts to make this place 
more "correct"?
>
> -- 
> blue skies,
>   Martin.
>
> Martin Schwidefsky
> Linux for zSeries Development & Services
> IBM Deutschland Entwicklung GmbH
>
> "Reality continues to ruin my life." - Calvin.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

