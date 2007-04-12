Return-Path: <linux-kernel-owner+w=401wt.eu-S965529AbXDLTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965529AbXDLTuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXDLTuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:50:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:52640 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965529AbXDLTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:50:39 -0400
Message-ID: <461E8CE8.2070808@vmware.com>
Date: Thu, 12 Apr 2007 12:47:52 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Hugh Dickins <hugh@veritas.com>,
       David Rientjes <rientjes@google.com>,
       Michel Lespinasse <walken@vmware.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Pte drop ptep_get_and_clear paravirt op.patch
References: <200704120530.l3C5Ubs0022821@zach-dev.vmware.com> <461E8D16.6060202@goop.org>
In-Reply-To: <461E8D16.6060202@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Zachary Amsden wrote:
>   
>> In shadow mode hypervisors, ptep_get_and_clear achieves the desired
>> purpose of keeping the shadows in sync by issuing a native_get_and_clear,
>> followed by a call to pte_update, which indicates the PTE has been
>> modified.
>>
>> Direct mode hypervisors (Xen) have no need for this anyway, and will trap
>> the update using writable pagetables.
>>
>> This means no hypervisor makes use of ptep_get_and_clear; there is no
>> reason to have it in the paravirt-ops structure.  Change confusing
>> terminology about raw vs. native functions into consistent use of
>> native_pte_xxx for operations which do not invoke paravirt-ops.
>>   
>>     
>
> Looks OK to me.  Are you going to put this into the pvops queue?
>
> Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>

Yes, the rest are still undergoing feedback.  I'll kick this in and 
fixup the damage it causes.

Zach
