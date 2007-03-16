Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXCPRC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXCPRC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965680AbXCPRC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:02:27 -0400
Received: from gw.goop.org ([64.81.55.164]:55951 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965656AbXCPRC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:02:26 -0400
Message-ID: <45FACD9F.6020604@goop.org>
Date: Fri, 16 Mar 2007 10:02:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 21/26] Xen-paravirt_ops: Use the hvc console infrastructure
 for Xen console
References: <20070301232443.195603797@goop.org> <20070301232528.926984984@goop.org> <20070316085451.GE23174@elte.hu>
In-Reply-To: <20070316085451.GE23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +	prod = intf->in_prod;
>> +	mb();
>> +	BUG_ON((prod - cons) > sizeof(intf->in));
>>     
>
> such mb()'s are typically a sign of "i have no clear idea what SMP 
> serialization rules apply here, but something is needed because 
> otherwise it breaks" ?

Hm, in this case its because it's sharing the memory with Xen, so
there's a particular ordering protocol.  It needs some comments.

    J

