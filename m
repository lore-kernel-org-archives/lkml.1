Return-Path: <linux-kernel-owner+w=401wt.eu-S965680AbXCPRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965680AbXCPRFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbXCPRFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:05:51 -0400
Received: from gw.goop.org ([64.81.55.164]:33568 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965680AbXCPRFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:05:50 -0400
Message-ID: <45FACE6E.3000901@goop.org>
Date: Fri, 16 Mar 2007 10:05:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Jan Beulich <JBeulich@novell.com>
Subject: Re: [patch 16/26] Xen-paravirt_ops: Allocate and free vmalloc areas
References: <20070301232443.195603797@goop.org> <20070301232528.297902504@goop.org> <20070316091648.GI23174@elte.hu>
In-Reply-To: <20070316091648.GI23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +struct vm_struct *alloc_vm_area(unsigned long size)
>>     
>
> this should go into mm/vmalloc.c.

The trouble is that it calls the arch-dependent vmalloc_sync_all(),
which is important for Xen's use of this function.  And without that
it's just a pointless wrapper around get_vm_area.

    J
