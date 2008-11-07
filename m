Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbYKGPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbYKGPQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYKGPPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:15:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47338 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbYKGPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:15:04 -0500
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Matthew Wilcox <matthew@wil.cx>, "Fischer, Anna" <anna.fischer@hp.com>,
       Greg KH <greg@kroah.com>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
From: Andi Kleen <andi@firstfloor.org>
References: <20081106154351.GA30459@kroah.com>
	<894107.30288.qm@web45108.mail.sp1.yahoo.com>
	<20081106164919.GA4099@kroah.com>
	<0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net>
	<20081106183630.GD11773@parisc-linux.org>
	<491371F0.7020805@codemonkey.ws>
Date: Fri, 07 Nov 2008 16:21:33 +0100
In-Reply-To: <491371F0.7020805@codemonkey.ws> (Anthony Liguori's message of "Thu, 06 Nov 2008 16:38:40 -0600")
Message-ID: <87d4h7pnnm.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori <anthony@codemonkey.ws> writes:
>
> What we would rather do in KVM, is have the VFs appear in the host as
> standard network devices.  We would then like to back our existing PV
> driver to this VF directly bypassing the host networking stack.  A key
> feature here is being able to fill the VF's receive queue with guest
> memory instead of host kernel memory so that you can get zero-copy
> receive traffic.  This will perform just as well as doing passthrough
> (at least) and avoid all that ugliness of dealing with SR-IOV in the
> guest.

But you shift a lot of ugliness into the host network stack again.
Not sure that is a good trade off.

Also it would always require context switches and I believe one
of the reasons for the PV/VF model is very low latency IO and having
heavyweight switches to the host and back would be against that.

-Andi

-- 
ak@linux.intel.com
