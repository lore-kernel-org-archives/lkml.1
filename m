Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbZJLSKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbZJLSKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757469AbZJLSKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:10:31 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:42055 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbZJLSKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iBxlhbBRCUnvtjUnVdIh7PXmuGGGSiMQiJCuq1Ze9UkXprRftS0w32D+uBMkXFYC2O
         ZG2UWBdA3JkBggEk+tL1q1qtM25WrrjgHxyEYFwlkvfbN41yWN3nO/3gAuTC8hV4opMj
         qUTGZ9fFG4bjDqXnXdQvbS9lH/wN8mIoj+gIU=
Message-ID: <4AD370EC.1050306@gmail.com>
Date: Mon, 12 Oct 2009 12:09:48 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Schlichter <thomas.schlichter@web.de>,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not   available
References: <200910100322.36857.thomas.schlichter@web.de> <4AD00C89.3000503@linux.intel.com> <20091011185114.GB18578@khazad-dum.debian.net> <4AD229FA.7020104@linux.intel.com> <20091011201953.GD18578@khazad-dum.debian.net>
In-Reply-To: <20091011201953.GD18578@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2009 02:19 PM, Henrique de Moraes Holschuh wrote:
> On Sun, 11 Oct 2009, Arjan van de Ven wrote:
>> Henrique de Moraes Holschuh wrote:
>>> On Fri, 09 Oct 2009, Arjan van de Ven wrote:
>>>>> I've found a problem with X.org not setting up MTRR for the
>>>>> framebuffer memory. After I investigated I think this is not a
>>>>> X.org problem, but a kernel issue.
>>>> is there any CPU left that does not support PAT ?
>>>
>>> A few million of them.  Like every Centrino laptop out there, unless the
>>> kernel blacklist for PAT on Intel CPUs is wrong.
>>
>> afaik it is extremely conservative right now. FAR too much so.
>
> That *still* means we need the patch in this thread.

I don't know that it is too conservative - the erratum which justifies 
the disablement (Core Solo/Duo erratum AE7, Pentium M erratum Y31, 
likely other IDs for it too) states that "A page whose PAT memory type 
is USWC while the relevant MTRR memory type is UC, the consolidated 
memory type may be treated as UC (rather than WC as specified in IA-32 
Intel® Architecture Software Developer's Manual). When this erratum 
occurs, the memory page may be as UC (rather than WC). This may have a 
negative performance impact." This is exactly the case being discussed 
here with the framebuffer which we're trying to set as WC with existing 
MTRRs set (or defaulting to) UC. This not only affects Pentium M but 
also the original Core Solo and Core Duo CPUs which surely is millions 
of existing laptops. It seems pretty clear-cut and there's no workaround 
identified, so I think we do indeed need a patch like this one.
