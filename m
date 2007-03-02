Return-Path: <linux-kernel-owner+w=401wt.eu-S2992618AbXCBQ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992618AbXCBQ4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992619AbXCBQ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:56:05 -0500
Received: from gw.goop.org ([64.81.55.164]:54306 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992618AbXCBQ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:56:01 -0500
Message-ID: <45E8571F.1050509@goop.org>
Date: Fri, 02 Mar 2007 08:55:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] Vmi fix highpte
References: <200703020254.l222smBB009668@zach-dev.vmware.com> <45E79529.9000305@goop.org> <45E79C72.4000806@goop.org> <45E7C4DD.1040403@vmware.com> <45E7C80E.1020107@goop.org> <45E7F405.6020507@vmware.com>
In-Reply-To: <45E7F405.6020507@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> I've been sending out this particular patch or a variant of it for a
> long time.  It did get lost for a while during the paravirt-ops
> conversion, however.  You're the first to give any feedback on it.

Oops, I guess so.  I've been doing a lot more Xen pagetable work for the
last couple of weeks, so it caught my eye this time.

>>>   Do you have any objection to me creating a patch for -mm tree that
>>> implements kmap_atomic_pte the way you have described above and
>>> attaching it to the Xen patch series, but leaving the current patch as
>>> is for now?
>>>     
>>
>> Not particularly, but it seems odd to put something in knowing its going
>> to be immediately replaced.  What's the urgency?
>>   
>
> Better to keep what is known working for now, even if it is going to
> be replaced later... code is easy to change in development cycles,
> less easy to fix when nearing release.  It really is easy to mess up
> one of the pte conversions by, say, shift the wrong value or calculate
> wrong or PAE dependent PTE offset.

Those are bugs that can occur, but they don't apply in this case.  The
vmi implementation of kmap_atomic_pte() would be:

static void *vmi_kmap_atomic_pte(struct page *page, enum km_type type)
{
	void *ptep = kmap_atomic(page, type);
	vmi_map_pt_hook(type, ptep, page_to_pfn(page));
	return ptep;
}

Right?  Which is functionally identical to the code in your patch,
except wrapped up in a new function.

    J
