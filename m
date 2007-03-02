Return-Path: <linux-kernel-owner+w=401wt.eu-S1422991AbXCBJxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422991AbXCBJxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422989AbXCBJxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:53:12 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51067 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422988AbXCBJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:53:10 -0500
Message-ID: <45E7F405.6020507@vmware.com>
Date: Fri, 02 Mar 2007 01:53:09 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org> <45E79C72.4000806@goop.org> <45E7C4DD.1040403@vmware.com> <45E7C80E.1020107@goop.org>
In-Reply-To: <45E7C80E.1020107@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> Yeah, actually that does work, since you pass the km_type, we can use
>> that.  But I would rather not respin this for 2.6.21; getting this
>> 100% right can be tricky, and we've already done a good deal of
>> testing on this patch the way it is.
>>     
>
> It seems fairly low risk to me; its basically the same structure with
> the same calls happening in the same order, but just slightly rearranged
> in the source.  Of course, if I'd seen this patch earlier I could have
> given you earlier feedback...
>   

I've been sending out this particular patch or a variant of it for a 
long time.  It did get lost for a while during the paravirt-ops 
conversion, however.  You're the first to give any feedback on it.

>>   Do you have any objection to me creating a patch for -mm tree that
>> implements kmap_atomic_pte the way you have described above and
>> attaching it to the Xen patch series, but leaving the current patch as
>> is for now?
>>     
>
> Not particularly, but it seems odd to put something in knowing its going
> to be immediately replaced.  What's the urgency?
>   

Better to keep what is known working for now, even if it is going to be 
replaced later... code is easy to change in development cycles, less 
easy to fix when nearing release.  It really is easy to mess up one of 
the pte conversions by, say, shift the wrong value or calculate wrong or 
PAE dependent PTE offset.  Plus it is harder to test, since you need > 
896 M memory for your VM before the code even gets run.

Not that I expect anything to go wrong with it, but I would prefer to 
err on the side of caution for now, that's all.

Zach
