Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYHaRxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYHaRxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYHaRxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:53:34 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:30951 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYHaRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cWi7cg5U97UVEcYSxyCVT0+o/Nax6SXrO2+wa5GEKKtt3+4b7HHACb6j13FzO3ldNI
         Ap9sm3YJXI4BSeDoq72xsHGINGYzs77YDpLNU/Smhc3mhC6b3c82kxLKlvSPs1zHNSMn
         JBUZ2Sp4GdIghcNl7UqQSgkN4uuULvlUTf1cU=
Message-ID: <19f34abd0808311053m2fbaa711j5bfc846d81cf34b4@mail.gmail.com>
Date: Sun, 31 Aug 2008 19:53:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] prevent ia64 from invoking irq handlers on offline CPUs
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jes@sgi.com,
       manfred@colorfullife.com, akpm@linux-foundation.org
In-Reply-To: <20080831175100.GD7015@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080831172814.GA15087@linux.vnet.ibm.com>
	 <19f34abd0808311046g47907414wf3ef939d0a7bbfdb@mail.gmail.com>
	 <20080831175100.GD7015@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 7:51 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>> > @@ -751,6 +749,7 @@ int __cpu_disable(void)
>> >        remove_siblinginfo(cpu);
>> >        cpu_clear(cpu, cpu_online_map);

Here ^^^

>> >        fixup_irqs();
>> > +       cpu_clear(cpu, cpu_online_map);
>> >        local_flush_tlb_all();
>> >        cpu_clear(cpu, cpu_callin_map);
>> >        return 0;
>>
>> Hm. Maybe my eyes are going bad. But isn't that now clearing the cpu
>> both before and after calling fixup_irqs()?
>
> I don't believe so...  I removed the earlier one and added the later
> one.  Or is there another one hidden somewhere that I missed?

See marker above. It's not removed, is it?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
