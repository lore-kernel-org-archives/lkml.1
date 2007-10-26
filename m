Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXJZAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXJZAgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXJZAgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:36:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56156 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXJZAgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:36:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=TQWRbMXtCMiZFdpWDXhdbLWXXG6ekGlrjIB87dugF0eunZK7sZaMZhphseTkPekmV
	j4KPJ0ZJOiIG+U3TPkw6g==
Message-ID: <47213668.50907@google.com>
Date: Thu, 25 Oct 2007 17:35:52 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
References: <20071025230758.945535769@crlf.corp.google.com> <20071026012217.4cc30390@the-village.bc.nu>
In-Reply-To: <20071026012217.4cc30390@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Thu, 25 Oct 2007 16:06:40 -0700
> Mike Waychison <mikew@google.com> wrote:
> 
>> Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.
>>
>> It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.
> 
> Historically this was done because people felt it was more secure. It
> also allows you to make some deductions about other activities on the
> disk but thats probably only a concern for very very security crazed
> compartmentalised boxes
> 
> Also historically at least FIBMAP could be abused to crash the system.
> Now if you can verify that has been fixed I have no problem, but given
> that I can find no record of that being fixed it would be wise to audit
> it first and review Chris Evans and other reports about what occurs when
> FIBMAP is passed random block numbers.
> 
> FIBMAP has another problem for this general use as well - it takes an int
> but the block number can now be bigger for very large files on 32bit.
> 
> Alan

I found Chris's comment about negative block numbers, I'll send a patch 
out for that.

You mentioned back in 99 about racing with ftruncate.  Is it sufficient 
to mutex_lock(i_mutex) and down_read(i_alloc_sem)?

Mike Waychison
