Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYKGPVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYKGPVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYKGPUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:20:55 -0500
Received: from outbound-mail-09.bluehost.com ([69.89.17.209]:59264 "HELO
	outbound-mail-09.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752352AbYKGPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:20:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CWvRwS277fzZHGuAGjgTPa+/X9DnskcdsHYNN9uC9bW/0jtlCIAxcsN25mnoK2SspxD/UvtNrDaky/mW017cCuxBXiTJyGMvewfGD/4Wf5qhFmTR+gd5jrX38dYe9Ha1;
Message-ID: <49145C14.1050409@uniscape.net>
Date: Fri, 07 Nov 2008 23:17:40 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       "Fischer, Anna" <anna.fischer@hp.com>, H L <swdevyid@yahoo.com>,
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
       "mingo@elte.hu" <mingo@elte.hu>, keir.fraser@eu.citrix.com,
       Leonid.Grossman@neterion.com, eddie.dong@intel.com,
       jun.nakajima@intel.com, avi@redhat.com
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <0199E0D51A61344794750DC57738F58E5E26F996C4@GVW1118EXC.americas.hpqcorp.net> <20081106183630.GD11773@parisc-linux.org> <491371F0.7020805@codemonkey.ws> <20081106225854.GA15439@parisc-linux.org> <20081107061952.GF3860@kroah.com>
In-Reply-To: <20081107061952.GF3860@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 124.76.3.39 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we are arguing what the software model the SR-IOV should be, let 
me ask two simple questions first:

1, What does the SR-IOV looks like?
2, Why do we need to support it?

I'm sure people have different understandings from their own view 
points. No one is wrong, but, please don't make thing complicated and 
don't ignore user requirements.

PCI SIG and hardware vendors create such thing intending to make 
hardware resource in one PCI device be shared from different software 
instances -- I guess all of us agree with this. No doubt PF is real 
function in the PCI device, but VF is different? No, it also has its own 
Bus, Device and Function numbers, and PCI configuration space and Memory 
Space (MMIO). To be more detailed, it can response to and initiate PCI 
Transaction Layer Protocol packets, which means it can do everything a 
PF can in PCI level. From these obvious behaviors, we can conclude PCI 
SIG model VF as a normal PCI device function, even it's not standalone.

As you know the Linux kernel is the base of various virtual machine 
monitors such as KVM, Xen, OpenVZ and VServer. We need SR-IOV support in 
the kernel because mostly it helps high-end users (IT departments, HPC, 
etc.) to share limited hardware resources among hundreds or even 
thousands virtual machines and hence reduce the cost. How can we make 
these virtual machine monitors utilize the advantage of SR-IOV without 
spending too much effort meanwhile remaining architectural correctness? 
I believe making VF represent as much closer as a normal PCI device 
(struct pci_dev) is the best way in current situation, because this is 
not only what the hardware designers expect us to do but also the usage 
model that KVM, Xen and other VMMs have already supported.

I agree that API in the SR-IOV pacth is arguable and the concerns such 
as lack of PF driver, etc. are also valid. But I personally think these 
stuff are not essential problems to me and other SR-IOV driver 
developers. People can refine things but don't want to recreate things 
in another totally different way especially that way doesn't bring them 
obvious benefits.

As I can see that we are now reaching a point that a decision must be 
made, I know this is such difficult thing in an open and free community 
but fortunately we have a lot of talented and experienced people here. 
So let's make it happen, and keep our loyal users happy!

Thanks,
Yu
