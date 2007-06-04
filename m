Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbXFDBHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbXFDBHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXFDBHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:07:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:41699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbXFDBHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:07:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,378,1175497200"; 
   d="scan'208";a="250414621"
From: Sheng Yang <sheng.yang@intel.com>
Organization: intel
To: Dave Jones <davej@redhat.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH]Multi-threaded Initcall with dependence support
Date: Mon, 4 Jun 2007 09:06:39 +0800
User-Agent: KMail/1.9.5
References: <200705281503.10918.sheng.yang@intel.com> <200705290947.53881.sheng.yang@intel.com> <20070531202655.GD31153@redhat.com>
In-Reply-To: <20070531202655.GD31153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040906.39594.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007 04:26, Dave Jones wrote:
> On Tue, May 29, 2007 at 09:47:53AM +0800, Yang Sheng wrote:
>  > On Tuesday 29 May 2007 06:52, Randy Dunlap wrote:
>  > > On Mon, 28 May 2007 15:03:10 +0800 Yang Sheng wrote:
>  > > > Why we need this:
>  > > >
>  > > > It can speed up the calling of initcalls, especially useful for some
>  > > > embed device.
>  > >
>  > > Can you give concrete example(s) of why we need this?
>  > > Any real configs/hardware where it helps and how much it helps.
>  >
>  > We didn't got the precise data at hand now, because we should build a
>  > complete stable initcall dependence relationship for it, but we can't do
>  > it now.
>  >
>  > But we have done a relative stable test in a common x86_64 machine, with
>  > 2 threads and one dependence relation(pnpacpi_init depends on pnp_init
>  > and acpi_init). The result is the time spending on initcall calling
>  > reducing from about _5s_ to _2s_ (make the kernel with the defconfig).
>  > We analyzed the dmesg and found the most of time was save by run
>  > ide_generic_init and piix_init in parallel.
>  >
>  > Of course the dependence in the test case is not sufficient, but the
>  > effect is shown.
>  >
>  > We think this patch would be very useful in some embed deviced which
>  > requires fast boot speed. Some server may benefit too because of it's
>  > long time for device initiation.
>
> If we decide to do this, we should also introduce a way to disable it
> at runtime with initcall=noparallel or something.  Why?


> Because right now when people say "my computer hangs during bootup"
> we can ask them to boot with initcall_debug and usually find out
> the last thing it did before it locked up.   If we parallelise this,
> the output will be a lot harder to decipher.

Thank you for the advice. I will introduce a parameter to do this. 

But what's about idea itself? I don't know whether people like this... It 
required a little more work on initcall writing. 

Maybe we could limit the multithread part in device_initcall? For it seems the 
most time consumed here, and the others in total just less than 1s(at least 
on my machine). 

Thanks. 
-- 
regards
Yang, Sheng
