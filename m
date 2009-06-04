Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZFDTF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZFDTF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZFDTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:05:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZFDTFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:05:06 -0400
Message-ID: <4A281AA9.50209@redhat.com>
Date: Thu, 04 Jun 2009 22:04:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
       agraf@suse.de, pmullaney@novell.com, pmorreale@novell.com,
       anthony@codemonkey.ws, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org, bhutchings@solarflare.com, andi@firstfloor.org,
       gregkh@suse.de, herber@gondor.apana.org.au, chrisw@sous-sol.org,
       shemminger@vyatta.com
Subject: Re: [RFC PATCH v2 03/19] vbus: add connection-client helper infrastructure
References: <20090409155200.32740.19358.stgit@dev.haskins.net> <20090409163057.32740.27829.stgit@dev.haskins.net> <20090604180611.GA16387@redhat.com> <4A280FE2.2090101@novell.com> <4A281161.8010109@redhat.com> <4A2812E3.6090108@novell.com>
In-Reply-To: <4A2812E3.6090108@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Oh, I don't doubt that (in fact, I was pretty sure that was the case
> based on some of the optimizations I could see in studying the c_t_u()
> path).  I just didn't realize there were other ways to do it if its a
> non "current" task. ;)
>
> I guess the enigma for me right now is what cost does switch_mm have? 
> (Thats not a slam against the suggested approach...I really do not know
> and am curious).
>   

switch_mm() is probably very cheap (reloads cr3), but it does dirty the 
current cpu's tlb.  When the kernel needs to flush a process' tlb, it 
will have to IPI that cpu in addition to all others.  This takes place, 
for example, after munmap() or after a page is swapped out (though 
significant batching is done there).

It's still plenty cheaper in my estimation.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

