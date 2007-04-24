Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbXDXBX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbXDXBX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXDXBX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:23:57 -0400
Received: from gw.goop.org ([64.81.55.164]:59695 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbXDXBX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:23:57 -0400
Message-ID: <462D5C3C.4000406@goop.org>
Date: Mon, 23 Apr 2007 18:24:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 03/25] xen: Add nosegneg capability to the vsyscall page
 notes
References: <20070423232941.476FB1801A4@magilla.sf.frob.com>
In-Reply-To: <20070423232941.476FB1801A4@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> + * It should contain:
>> + *	hwcap 0 nosegneg
>> + * to match the mapping of bit to name that we give here.
>>     
>
> This needs to be "hwcap 0 nosegneg" to match:
>
>   
>> +NOTE_KERNELCAP_BEGIN(1, 2)
>> +NOTE_KERNELCAP(1, "nosegneg")
>> +NOTE_KERNELCAP_END
>>     
>
> The actual bits you are using should be fine.  (You're intentionally
> skipping bit 0 to work around hold glibc bugs, which you might want to add
> to the comments.  Also a comment or perhaps using 1<<1 syntax would make it
> more clear that "2" is the bit mask containing bit 1 and that's why it has
> to be 2, and not because of some other magical property of 2.)  But if
> kernel packagers don't write the matching bit number in their ld.so.conf.d
> files, then ld.so.cache lookups won't work right.

I have to admit I still don't really understand all this.  Is it
documented somewhere?

What does "hwcap 0 nosegneg" actually mean?  What does the "0" mean here?

In the ELF note, what does the "nosegneg" string mean?  How is it used? 
Is it compared to the "nosegneg" in ld.so.conf?  How does this relate to
the bitfields?

Thanks,
    J
