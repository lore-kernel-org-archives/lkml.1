Return-Path: <linux-kernel-owner+w=401wt.eu-S1751260AbXB1UMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbXB1UMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXB1UMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:12:49 -0500
Received: from gw.goop.org ([64.81.55.164]:41625 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXB1UMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:12:49 -0500
Message-ID: <45E5E235.60707@goop.org>
Date: Wed, 28 Feb 2007 12:12:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to pack
 and unpack pagetable entries
References: <20070227081337.434798469@goop.org> <20070227081630.311681690@goop.org> <20070227100850.GA10827@elte.hu> <45E47DEF.70405@goop.org> <20070228083203.GB8866@elte.hu>
In-Reply-To: <20070228083203.GB8866@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Yes, but it happens after asm/paravirt.h has already included some 
>> things, and it ends up causing problems.  paravirt.h still defines 
>> various stub functions in the !CONFIG_PARAVIRT case, so it needs to do 
>> the includes either way.
>>     
>
> hm, it then needs to be fixed first, instead of adding to the mess.
>   

OK, I've fixed this by hoisting all the native_* implementations into
pgtable.h.  In the !PARAVIRT case the normal macros directly use the
native_* functions, and in the PARAVIRT case they're used by the native
paravirt_ops.  This has the nice property of avoiding this specific
problem, and also generally removes code duplication.

    J
