Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbXCaIUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbXCaIUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbXCaIUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:20:25 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34173 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbXCaIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:20:23 -0400
Message-ID: <460E27A4.1040606@vmware.com>
Date: Sat, 31 Mar 2007 01:19:32 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] VMI paravirt-ops bugfix for 2.6.21
References: <460E1FC7.5030107@vmware.com> <460E1796.2070607@goop.org>
In-Reply-To: <460E1796.2070607@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>
> The comment only talks about disabling interrupts for lazy_mmu, but this
> seems to do it for lazy_cpu as well.  Is that OK?  What happens if
> someone wants to change interrupt states under lazy_cpu; I can't think
> of an inherent reason why that wouldn't be allowed (though I don't think
> it happens now).
>   

Well, lazy cpu is used only for context switch.  Changing interrupt 
states won't happen there.

> This kind of logic is a bit clunky anyway; would it be better to simply
> have separate enable/disable functions?  Or at least separate functions
> per mode?
>   

I want to do a cleaner fix for 2.6.22; this is pretty clunky, agree.  
But it is still better to have fewer paravirt-ops.  Perhaps lazy_enter / 
flush would be more semantically useful.

Zach
