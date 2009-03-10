Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZCJWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZCJWpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZCJWo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:44:56 -0400
Received: from gw.goop.org ([64.81.55.164]:34298 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZCJWoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:44:55 -0400
Message-ID: <49B6ED64.2090007@goop.org>
Date: Tue, 10 Mar 2009 15:44:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] paravirt/xen: add pvop for page_is_ram
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <1235786365-17744-10-git-send-email-jeremy@goop.org> <49B5BD63.1090909@zytor.com> <49B6D94F.9070902@goop.org> <49B6E7EB.2040009@zytor.com>
In-Reply-To: <49B6E7EB.2040009@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>> 3) isn't yet relevant to Xen; ioremap can't map granted pages either, so
>> 2) isn't terribly relevent, so the main motivation for this patch is
>> 1).  This allows us to reject usermode attempts to map granted pages,
>> rather than oopsing (as a failed set_pte will raise a page fault).
>>
>> So, more cosmetic than essential, but I don't see a better way to
>> implement this functionality if its to be there at all.
>>
>>     
>
> OK, that is a valid usage case and I agree about repurposing the
> existing interface.  However, it is also a definition change in the
> interface, so it really should be renamed first.
>
> Would you be willing to break this patch up into one which renames the
> interface and then a second which adds the pv hook?
>   

Well, on reflection, given that the thing we're testing for is "is page 
is allowed to be mapped by /dev/mem?", and devmem_is_allowed() already 
exists for precisely that reason, the answer is to put the hook there...

But, it seems I got the logic wrong anyway.  /dev/mem doesn't allow RAM 
pages to be mapped anyway, so granted pages masquerading as RAM will not 
be mappable via /dev/mem.  So I think we can safely drop this patch with 
no futher ado.

    J
