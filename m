Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYFDN67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYFDN67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbYFDN6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:58:51 -0400
Received: from gw.goop.org ([64.81.55.164]:47818 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYFDN6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:58:50 -0400
Message-ID: <48469F71.4080303@goop.org>
Date: Wed, 04 Jun 2008 14:58:09 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <484691CB.6090809@goop.org> <48469D30.40901@sgi.com>
In-Reply-To: <48469D30.40901@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Mike Travis wrote:
>>     
>>>   * Declare the pda as a per cpu variable.
>>>
>>>   * Make the x86_64 per cpu area start at zero.
>>>
>>>   * Since the pda is now the first element of the per_cpu area, cpu_pda()
>>>     is no longer needed and per_cpu() can be used instead.  This also
>>> makes
>>>     the _cpu_pda[] table obsolete.
>>>
>>>   * Since %gs is pointing to the pda, it will then also point to the
>>> per cpu
>>>     variables and can be accessed thusly:
>>>
>>>     %gs:[&per_cpu_xxxx - __per_cpu_start]
>>>
>>>       
>
>   
> The above is only a partial story (I folded the two patches but didn't
> update the comments correctly.]  The variables are already offset from
> __per_cpu_start by virtue of the .data.percpu section being based at
> zero.  Therefore only the %gs register needs to be set to the base of
> each cpu's percpu section to resolve the target address:
>
>         %gs:&per_cpu_xxxx
>   

Oh, good.  I'd played with trying to make that work at one point, and 
got lost in linker bugs and/or random version-specific strangeness. 

    J
