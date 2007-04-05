Return-Path: <linux-kernel-owner+w=401wt.eu-S1946049AbXDEHqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049AbXDEHqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 03:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946054AbXDEHqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 03:46:14 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:50998
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946049AbXDEHqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 03:46:13 -0400
Message-Id: <4614C598.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 05 Apr 2007 08:47:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       <virtualization@lists.osdl.org>, "Roland McGrath" <roland@redhat.com>,
       "Andi Kleen" <ak@suse.de>, "lkml" <linux-kernel@vger.kernel.org>,
       "Zachary Amsden" <zach@vmware.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped
	location with COMPAT_VDSO
References: <20070405045825.511024444@goop.org>
 <20070405045843.333498131@goop.org> <4614BD10.76E4.0078.0@novell.com>
 <4614A5DA.9050700@goop.org>
In-Reply-To: <4614A5DA.9050700@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 05.04.07 09:31 >>>
>Jan Beulich wrote:
>> While there's a certain level of control on what DT_* may appear in the
>> vDSO, not even considering other than the above types seems fragile to
>> me. Since future additions to the set are supposedly following a fixed
>> scheme (distinguishing pointers and values via the low bit when below
>> OLD_DT_LOOS, and using sub-ranges when between DT_HIOS and
>> OLD_DT_HIOS), at least also handling those would seem like a good
>> idea, as would warning about unrecognized types.
>
>I wasn't aware of this scheme.  Where is it documented?

Regarding the low bit part, quoting from working gABI chapter 5: "To make
it simpler for tools to interpret the contents of dynamic section entries, the
value of each tag, except for those in two special compatibility ranges, will
determine the interpretation of the d_un union. A tag whose value is an
even number indicates a dynamic section entry that uses d_ptr. A tag
whose value is an odd number indicates a dynamic section entry that uses
d_val or that uses neither d_ptr nor d_val. Tags whose values are less
than the special value DT_ENCODING and tags whose values fall between
DT_HIOS and DT_LOPROC do not follow these rules."

Regarding the OS range, all I can point you to is binutils' include/elf/common.h.

Jan
