Return-Path: <linux-kernel-owner+w=401wt.eu-S932372AbZIVQaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbZIVQaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932358AbZIVQaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:30:05 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34415 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357AbZIVQaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:30:03 -0400
Date: Tue, 22 Sep 2009 09:29:57 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [RFC] Virtual Machine Device Queues(VMDq) support on KVM
Message-ID: <20090922092957.17e68cbc@s6510>
In-Reply-To: <200909221350.54847.arnd@arndb.de>
References: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB94861@PDSMSX501.ccr.corp.intel.com>
	<20090921162718.GM26034@sequoia.sous-sol.org>
	<20090922103807.GA2555@redhat.com>
	<200909221350.54847.arnd@arndb.de>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 13:50:54 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 22 September 2009, Michael S. Tsirkin wrote:
> > > > More importantly, when virtualizations is used with multi-queue
> > > > NIC's the virtio-net NIC is a single CPU bottleneck. The virtio-net
> > > > NIC should preserve the parallelism (lock free) using multiple
> > > > receive/transmit queues. The number of queues should equal the
> > > > number of CPUs.
> > > 
> > > Yup, multiqueue virtio is on todo list ;-)
> > > 
> > 
> > Note we'll need multiqueue tap for that to help.
> 
> My idea for that was to open multiple file descriptors to the same
> macvtap device and let the kernel figure out the  right thing to
> do with that. You can do the same with raw packed sockets in case
> of vhost_net, but I wouldn't want to add more complexity to the
> tun/tap driver for this.
> 
> 	Arnd <><


Or get tap out of the way entirely. The packets should not have
to go out to user space at all (see veth)
