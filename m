Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbXEaU1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbXEaU1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXEaU11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:27:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbXEaU10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:27:26 -0400
Date: Thu, 31 May 2007 16:26:55 -0400
From: Dave Jones <davej@redhat.com>
To: Yang Sheng <sheng.yang@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH]Multi-threaded Initcall with dependence support
Message-ID: <20070531202655.GD31153@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yang Sheng <sheng.yang@intel.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-kernel@vger.kernel.org
References: <200705281503.10918.sheng.yang@intel.com> <20070528155229.26a6848e.randy.dunlap@oracle.com> <200705290947.53881.sheng.yang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705290947.53881.sheng.yang@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 09:47:53AM +0800, Yang Sheng wrote:
 > On Tuesday 29 May 2007 06:52, Randy Dunlap wrote:
 > > On Mon, 28 May 2007 15:03:10 +0800 Yang Sheng wrote:
 > > > Why we need this:
 > > >
 > > > It can speed up the calling of initcalls, especially useful for some
 > > > embed device.
 > >
 > > Can you give concrete example(s) of why we need this?
 > > Any real configs/hardware where it helps and how much it helps.
 > >
 > 
 > We didn't got the precise data at hand now, because we should build a complete  
 > stable initcall dependence relationship for it, but we can't do it now. 
 > 
 > But we have done a relative stable test in a common x86_64 machine, with 2 
 > threads and one dependence relation(pnpacpi_init depends on pnp_init and 
 > acpi_init). The result is the time spending on initcall calling reducing from 
 > about _5s_ to _2s_ (make the kernel with the defconfig). We analyzed the 
 > dmesg and found the most of time was save by run ide_generic_init and 
 > piix_init in parallel. 
 > 
 > Of course the dependence in the test case is not sufficient, but the effect is 
 > shown. 
 > 
 > We think this patch would be very useful in some embed deviced which requires 
 > fast boot speed. Some server may benefit too because of it's long time for 
 > device initiation. 

If we decide to do this, we should also introduce a way to disable it
at runtime with initcall=noparallel or something.  Why?
Because right now when people say "my computer hangs during bootup"
we can ask them to boot with initcall_debug and usually find out
the last thing it did before it locked up.   If we parallelise this,
the output will be a lot harder to decipher.

	Dave

-- 
http://www.codemonkey.org.uk
