Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbYBLCwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbYBLCwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 21:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbYBLCwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 21:52:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755587AbYBLCwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:52:37 -0500
Date: Mon, 11 Feb 2008 18:51:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: greg@kroah.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86_64: check msr to get mmconfig for amd family
 10h opteron v3
Message-Id: <20080211185115.87e878d3.akpm@linux-foundation.org>
In-Reply-To: <200802111820.47244.yinghai.lu@sun.com>
References: <200802111643.17265.yinghai.lu@sun.com>
	<200802111648.35299.yinghai.lu@sun.com>
	<20080211170944.8b567a89.akpm@linux-foundation.org>
	<200802111820.47244.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 18:20:46 -0800 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> On Monday 11 February 2008 05:09:44 pm Andrew Morton wrote:
> > On Mon, 11 Feb 2008 16:48:35 -0800
> > Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > 
> > > From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> > > 
> > > so even booting kernel with acpi=off or even MCFG is not there, we still can
> > > use MMCONFIG.
> > > 
> > 
> > This patch threw a big reject.  I didn't check why.
> > 
> > 
> > > +		pci_direct_conf1.read(0, bus, devfn, 0, 4, &l);
> > 
> > When I fixed the reject, compilation failed here.
> > 
> > arch/x86/pci/mmconfig-shared.c: In function 'pci_mmcfg_check_hostbridge':
> > arch/x86/pci/mmconfig-shared.c:214: error: 'pci_direct_conf1' undeclared (first use in this function)
> > 
> > 
> > What kernel are you patching?
> > 
> 
> linus tree. 

hm.  So why didn't it compile?  pci_direct_conf1 is defined over in
arch/x86/pci/direct.c and is not mentioned in any header file.

> other three are ok?

Well, they applied, but I didn't review, build-test or merge them.
