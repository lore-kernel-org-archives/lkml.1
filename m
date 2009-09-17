Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbZIQIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbZIQIOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZIQIOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbZIQIOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:14:02 -0400
Date: Thu, 17 Sep 2009 04:14:01 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Message-ID: <1671727226.207651253175241980.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <976992170.207631253175200763.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to
 hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,
I check your application. It won't work correctly. You are calling return_unused_memory in xen_memory_setup that is too soon.
When you are calling it, there is no hole in map in any case. Calling should be in xen_post_allocator_init function (in arch/x86/xen/mmu.c).

Mirek
----- "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> From: "Jeremy Fitzhardinge" <jeremy@goop.org>
> To: "Miroslav Rezanina" <mrezanin@redhat.com>
> Cc: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
> Sent: Thursday, September 17, 2009 6:54:56 AM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
> Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
>
> On 09/16/09 21:43, Miroslav Rezanina wrote:
> > Ups.....This should not be commented out. I will resent the patch
> with
> > correct (uncommented) line.
> 
> I've already applied a variant of your patch.  Check the
> rebase/core-freemem branch in xen.git.
> 
>     J
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel

