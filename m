Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZIUQVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZIUQVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZIUQVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:21:39 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56639 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbZIUQVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:21:38 -0400
Date: Mon, 21 Sep 2009 09:21:30 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mst@redhat.com" <mst@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC] Virtual Machine Device Queues(VMDq) support on KVM
Message-ID: <20090921092130.30984dbd@s6510>
In-Reply-To: <200909211637.23299.rusty@rustcorp.com.au>
References: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB94861@PDSMSX501.ccr.corp.intel.com>
	<20090901090518.1193e412@nehalam>
	<200909211637.23299.rusty@rustcorp.com.au>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 16:37:22 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> > > Actually this framework can apply to traditional network adapters which have
> > > just one tx/rx queue pair. And applications using the same user/kernel interface
> > > can utilize this framework to send/receive network traffic directly thru a tx/rx
> > > queue pair in a network adapter.
> > > 

More importantly, when virtualizations is used with multi-queue NIC's the virtio-net
NIC is a single CPU bottleneck. The virtio-net NIC should preserve the parallelism (lock
free) using multiple receive/transmit queues. The number of queues should equal the
number of CPUs.
