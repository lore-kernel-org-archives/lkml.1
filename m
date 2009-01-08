Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbZAHTdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbZAHTdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZAHTdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:33:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:54753 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZAHTda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:33:30 -0500
Message-ID: <496654AE.50600@kernel.org>
Date: Thu, 08 Jan 2009 11:31:58 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/5] cpumask: update irq_desc to use cpumask_var_t
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>	 <20090107195832.465094000@polaris-admin.engr.sgi.com> <86802c440901071227n2d110757ye1bd12e689502ebc@mail.gmail.com> <49652D92.8020105@sgi.com> <49656FCF.9090602@kernel.org> <49661F8B.5070103@sgi.com>
In-Reply-To: <49661F8B.5070103@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Yinghai Lu wrote:
> ...
>>> Or am I missing your point?
>> static void init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
>>                  struct irq_desc *desc, int cpu)
>> {
>>         memcpy(desc, old_desc, sizeof(struct irq_desc));
>>
>>
>> will overwrite new_desc->affinity and pending_mask
>>
>> YH
> 
> Yup, apparently I was missing your point (banging on head once more).
> 
> Thanks for spotting this!
> 
> Ingo - what's the state of tip/cpus4096?  Shall I push this as an
> append patch, or redo the original so bisectability works.
> 
> Also, Yinghai - would you know of a straight forward way to test
> the irq migration?   I have taken cpus offline and back online
> but wasn't sure if any irq's were being moved off of cpu 0 which
> cannot be taken offline.

use echo "mask" > /proc/irq/xxx/smp_affinity to change affinity

and check /proc/interrupts and in /sys/log/messages i will said allocate new irq desc on some other node/cpu.

YH
