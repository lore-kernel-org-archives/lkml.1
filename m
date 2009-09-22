Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZIVLvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZIVLvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbZIVLvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:51:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZIVLvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:51:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC] Virtual Machine Device Queues(VMDq) support on KVM
Date: Tue, 22 Sep 2009 13:50:54 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: Chris Wright <chrisw@sous-sol.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org,
       "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB94861@PDSMSX501.ccr.corp.intel.com> <20090921162718.GM26034@sequoia.sous-sol.org> <20090922103807.GA2555@redhat.com>
In-Reply-To: <20090922103807.GA2555@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909221350.54847.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+5Tk4mdsSBrAID+Ky/wbZRbaTgDkNRlQeRM9w
 x2lb4Cd0aNma001cErfz/2UPVxb9vSo151+gw9wzN+zxTtIERi
 V2lWNO9hhw7XgXau5PHVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Michael S. Tsirkin wrote:
> > > More importantly, when virtualizations is used with multi-queue
> > > NIC's the virtio-net NIC is a single CPU bottleneck. The virtio-net
> > > NIC should preserve the parallelism (lock free) using multiple
> > > receive/transmit queues. The number of queues should equal the
> > > number of CPUs.
> > 
> > Yup, multiqueue virtio is on todo list ;-)
> > 
> 
> Note we'll need multiqueue tap for that to help.

My idea for that was to open multiple file descriptors to the same
macvtap device and let the kernel figure out the  right thing to
do with that. You can do the same with raw packed sockets in case
of vhost_net, but I wouldn't want to add more complexity to the
tun/tap driver for this.

	Arnd <><
