Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0CLLNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:13:44 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:34164 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab0CLLNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Xzt0IJoA8w0Jba2LwtGyfCVflri4mDuNVku0GsbgcstTejAfJPKB5gvwyqNDVno6nv
         qsXdvh7kHv8hCsigD7yDJFlgHxZkJxl7LwwMUlHSI/9hwU03TBHBMUFhwXYUi8O5UhIb
         DRbllMUd7/Cceyv9SF/WuHBINQjpknu7ff8Ag=
Message-ID: <4B9A21E3.4020607@warmcat.com>
Date: Fri, 12 Mar 2010 11:13:39 +0000
From: Andy Green <andy@warmcat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc14 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stanislav Brabec <utx@penguin.cz>
CC: Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, thommycheck@gmail.com,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com
Subject: Re: bit errors on spitz
References: <20100305212708.GC21773@elf.ucw.cz>	 <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>	 <20100308072858.GA29939@atrey.karlin.mff.cuni.cz>	 <20100308082530.GA1982@atrey.karlin.mff.cuni.cz>	 <4B98EF5D.5000609@warmcat.com> <1268322155.3990.114.camel@hammer.suse.cz>	 <4B995EE1.1050609@warmcat.com> <1268384824.4963.35.camel@utx.utx.cz>	 <4B9A0A71.7010206@warmcat.com> <1268390588.4963.66.camel@utx.utx.cz>
In-Reply-To: <1268390588.4963.66.camel@utx.utx.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/10 10:43, Somebody in the thread at some point said:
> Andy Green wrote:
>
>> In that case is the PXA CF driver PIO?  Then it can be the same load on
>> Vcore issue in disguise.
>
> There is a proprietary ASIC chip (Sharp Scoop) that handles CF and HDD
> access (and also several additional GPIOs):
> http://www.penguin.cz/~utx/zaurus/datasheets/ASIC_S1L50752B26B200/412752.PDF

Right but not thinking about its power arrangements, rather the load on 
the CPU itself when it's transferring data to / from CF interface (via 
this ASIC).

If the ASIC has bus master DMA and that's used by the driver then fair 
enough, otherwise if it is done by PIO in the driver "while using CF" 
(as mentioned in most symptoms) becomes the same as saying "during 100% 
load on CPU" which is what leads to dents in Vcore and potential 
instability by that same Vcore path.

-Andy
