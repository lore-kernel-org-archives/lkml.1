Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZC0Q2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZC0Q2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZC0Q2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:28:15 -0400
Received: from gw.goop.org ([64.81.55.164]:33815 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbZC0Q2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:28:14 -0400
Message-ID: <49CCFE9C.6060702@goop.org>
Date: Fri, 27 Mar 2009 09:28:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lguest@ozlabs.org, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/5] lguest: avoid accidental recycling of pgdir pages
References: <200903271022.28863.rusty@rustcorp.com.au> <49CC1B1C.3080102@goop.org> <200903271154.22450.rusty@rustcorp.com.au>
In-Reply-To: <200903271154.22450.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
>> You can't just do this in tlb flush?
>>     
>
> I don't think so.  The problem is that lguest tracks 4 toplevels, using random
> replacement.  This cache is indexed by cr3 value.
>
> Lguest assumes it's told about all pte removals or changes, but simple
> additions get faulted in.  If a pgdir page gets reused we'll potentially have
> stale values from its previous life as a pgdir, no?
>   

Yes, but when you get a tlb flush hypercall, couldn't you also look up 
the corresponding shadow pte and zap it so that it will get repopulated 
next time around?  And a full tlb flush would just zap the entire 
shadow.  After all, the shadow pagetable is just a glorified 
software-managed tlb...

    J
