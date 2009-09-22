Return-Path: <linux-kernel-owner+w=401wt.eu-S1751296AbZIVSew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbZIVSew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbZIVSew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:34:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbZIVSeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:34:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [RFC] Virtual Machine Device Queues(VMDq) support on KVM
Date: Tue, 22 Sep 2009 20:34:28 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
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
References: <C85CEDA13AB1CF4D9D597824A86D2B9006AEB94861@PDSMSX501.ccr.corp.intel.com> <200909221350.54847.arnd@arndb.de> <20090922092957.17e68cbc@s6510>
In-Reply-To: <20090922092957.17e68cbc@s6510>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909222034.28865.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19zU4lnGyDT5ZH7UNEOyzwbP1PHgjxQp0BfgYr
 YdWplNeazAT5CrmUt/9//0srAKA7a3vJUZcLCqLb9EsKCo3Om4
 AAhn2EjI5Jd0J+hPHwjiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Stephen Hemminger wrote:
> > My idea for that was to open multiple file descriptors to the same
> > macvtap device and let the kernel figure out the  right thing to
> > do with that. You can do the same with raw packed sockets in case
> > of vhost_net, but I wouldn't want to add more complexity to the
> > tun/tap driver for this.
> > 
> Or get tap out of the way entirely. The packets should not have
> to go out to user space at all (see veth)

How does veth relate to that, do you mean vhost_net? With vhost_net,
you could still open multiple sockets, only the access is in the kernel.
Obviously, once it all is in the kernel, that could be done under the
covers, but I think it would be cleaner to treat vhost_net purely as
a way to bypass the syscalls for user space, with as little as possible
visible impact otherwise.

	Arnd <><
