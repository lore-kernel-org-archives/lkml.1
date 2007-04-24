Return-Path: <linux-kernel-owner+w=401wt.eu-S1161657AbXDXGSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161657AbXDXGSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161661AbXDXGSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:18:39 -0400
Received: from gw.goop.org ([64.81.55.164]:59660 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161657AbXDXGSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:18:38 -0400
Message-ID: <462DA159.2030600@goop.org>
Date: Mon, 23 Apr 2007 23:19:05 -0700
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
References: <20070424042653.37F421801A4@magilla.sf.frob.com>
In-Reply-To: <20070424042653.37F421801A4@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> I have to admit I still don't really understand all this.  Is it
>> documented somewhere?
>>     
>
> I have explained it in public more than once, but I don't know off hand
> anywhere that was helpfully recorded.
>   

Thanks very much.  I'd been poking about, but the closest I came to an
actual description was various patches fixing bugs, so it was a little
incomplete.

> For example, a Xen-enabled kernel can use a single vDSO image (or a single
> pair of int80/sysenter images), containing the "nosegneg" hwcap note.  When
> there is no need for it (native or hvm or 64-bit hv or whatever), it just
> clears the mask word.  If you actually do this, you'll want to modify the
> NOTE_KERNELCAP_BEGIN macro to define a global label you can use with VDSO_SYM.
>   

Thanks for the pointer.  I'd been getting a bit of heat for enabling the
nonegseg flag unconditionally.  If I can make Xen-specific then that
will be one less source of complaints.

    J
