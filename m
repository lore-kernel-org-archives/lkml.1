Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbYGOTF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbYGOTF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761456AbYGOTFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:05:22 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45841 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760937AbYGOTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:05:19 -0400
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
From: Zachary Amsden <zach@vmware.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "yhlu.kernel@gmail.com" <yhlu.kernel@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080715185123.GA31445@linux-os.sc.intel.com>
References: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
	 <20080715185123.GA31445@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 12:04:18 -0700
Message-Id: <1216148658.6620.192.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 11:51 -0700, Suresh Siddha wrote:
> On Tue, Jul 15, 2008 at 11:38:50AM -0700, Zachary Amsden wrote:
> >
> > Nacked-by: Zachary Amsden <zach@vmware.com>
> >
> > What are you doing here and why aren't you cc-ing the maintainers?
> 
> Sorry. I was about to bring you into the loop.
> 
> Yinghai posted 32bit native apic_ops(similar to my 64bit apic ops patch, which
> is different from pv_apic_ops) which is in tip/x86/x2apic and proposed a fix
> for VMI case aswell.
> 
> Based on my understanding, tip/x86/x2apic git commit
> 94a8c3c2437c8946f1b6c8e0b2c560a7db8ed3c6 is wrong and it should be fixed with
> something like
> http://marc.info/?l=linux-kernel&m=121614328831237&w=2

Looks better, but I need to read more context to find out where the
apic_ops variable comes from; I'll read the list for patches.

You are correct in that we will want to use the same wait_icr_idle
routine as native hardware; it's not clear from just this patch how that
happens.

Also, the VMI operations are sensitive to parameter order because they
interface with an ABI at the other end.  I need to check the parameter
order for apic read / write is still consistent with the ABI.

Zach

