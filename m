Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbXBVUVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbXBVUVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXBVUVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:21:38 -0500
Received: from gw.goop.org ([64.81.55.164]:53952 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbXBVUVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:21:38 -0500
Message-ID: <45DDFB4D.9050809@goop.org>
Date: Thu, 22 Feb 2007 12:21:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 10/21] Xen-paravirt: add hooks to intercept mm creation
 and destruction
References: <20070216022449.739760547@goop.org> <20070216022531.267584466@goop.org> <20070222201644.GA4938@ucw.cz>
In-Reply-To: <20070222201644.GA4938@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>
>   
>> @@ -126,6 +126,12 @@ struct paravirt_ops
>>  	void (*io_delay)(void);
>>  	void (*const_udelay)(unsigned long loops);
>>  
>> +	void (fastcall *activate_mm)(struct mm_struct *prev,
>> +				     struct mm_struct *next);
>> +	void (fastcall *dup_mmap)(struct mm_struct *oldmm, 
>> +				  struct mm_struct *mm);
>> +	void (fastcall *exit_mmap)(struct mm_struct *mm);
>> +
>>     
>
> Why the fastcall stuff?  Why is io_delay different from activate_mm in
> this regard?
>   

That's crud; I forgot to remove it.  Everything is effectively fastcall
now that -mregparm=3 is always on.

    J
