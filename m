Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbXKMSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbXKMSwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762574AbXKMSud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:50:33 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:40809 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762565AbXKMSua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:50:30 -0500
Date: Tue, 13 Nov 2007 10:49:25 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Andi Kleen <ak@suse.de>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       rusty@rustcorp.com.au, chrisw@sous-sol.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
Message-ID: <20071113184925.GB10344@localdomain>
References: <11946338683305-git-send-email-gcosta@redhat.com> <200711131333.41946.ak@suse.de> <47399DC8.7000504@redhat.com> <200711131409.41959.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711131409.41959.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 02:09:41PM +0100, Andi Kleen wrote:
>
>> If vsmp is selected, PARAVIRT will be too, and the interrupt code will
>> be patched.
>> the vsmp option triggers a select statement.
>> 
>> the ifdef only exists because, as I said, the code itself will be always
>> compiled in, to avoid an ifdef in setup_64.c. So it's just a taking it
>> from here, putting it there issue.
>
>Peeking around needlessly in pci config space at each boot just to avoid an 
>ifdef is not an good idea.

Agreed.  vsmp_init does not make sense unless the irq ops are patched.  We
can call vsmp_init under #ifdef CONFIG_PARAVIRT.

Thanks,
Kiran
