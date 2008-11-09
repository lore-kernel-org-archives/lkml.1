Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYKIMqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYKIMqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYKIMqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:46:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56544 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbYKIMqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:46:21 -0500
Message-ID: <4916DB16.2040709@redhat.com>
Date: Sun, 09 Nov 2008 14:44:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Fischer, Anna" <anna.fischer@hp.com>, H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106180354.GA17429@kroah.com>
In-Reply-To: <20081106180354.GA17429@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> It's that "second" part that I'm worried about.  How is that going to
> happen?  Do you have any patches that show this kind of "assignment"?
>
>   

For kvm, this is in 2.6.28-rc.

Note there are two ways to assign a device to a guest:

- run the VF driver in the guest: this has the advantage of best 
performance, but requires pinning all guest memory, makes live migration 
a tricky proposition, and ties the guest to the underlying hardware.
- run the VF driver in the host, and use virtio to connect the guest to 
the host: allows paging the guest and allows straightforward live 
migration, but reduces performance, and hides any features not exposed 
by virtio from the guest.


-- 
error compiling committee.c: too many arguments to function

