Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752850AbYLQS7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYLQS7y (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYLQS7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:59:41 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:51755 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752355AbYLQS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:59:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=j7t8asgbqCp7WQgIdKovwZq5VN4tUSGJ0qCDn+GTbOPpLhMBvJopQAz4PPdsmzYFkcI9RdPub8akC+zJLmH0MpEob/NK2lueIsbj6BhA/ibibLBM7zcxJHp/TMV6Lw2l;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Subject: Re: [PATCH 0/13 v7] PCI: Linux kernel SR-IOV support
Date: Wed, 17 Dec 2008 10:59:34 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Yu Zhao <yu.zhao@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Chiang, Alexander" <achiang@hp.com>,
        "Helgaas, Bjorn" <bjorn.helgaas@hp.com>,
        "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
        "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "matthew@wil.cx" <matthew@wil.cx>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "rdreier@cisco.com" <rdreier@cisco.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
References: <20081121183605.GA7810@yzhao12-linux.sh.intel.com> <200812161523.55238.jbarnes@virtuousgeek.org> <0199E0D51A61344794750DC57738F58E5E29B33E3C@GVW1118EXC.americas.hpqcorp.net>
In-Reply-To: <0199E0D51A61344794750DC57738F58E5E29B33E3C@GVW1118EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812171059.36188.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 17, 2008 3:42 am Fischer, Anna wrote:
> I have two minor comments on this topic.
>
> 1) Currently the PF driver is called before the kernel initializes VFs and
> their resources, and the current API does not allow the PF driver to
> detect that easily if the allocation of the VFs and their resources
> has succeeded or not. It would be quite useful if the PF driver gets
> notified when the VFs have been created successfully as it might have
> to do further device-specific work *after* IOV has been enabled.

You're thinking of after the VFs are created the VF drivers (which may or may 
not be part of the PF driver) may not be able to communicate back to the PF 
driver that something else needs to be done (I remember seeing this in the 
earlier thread, should have included it in my post, sorry)?  I'm not sure if 
it makes sense to add an interface like that to the core until we have feel 
for what the PF/VF drivers are going to want... Or do you have something 
specific in mind right now?  If/until we have something in the core, it seems 
like this could be done on a per PF/VF driver basis for now.

> 2) Configuration of SR-IOV: the current API allows to enable/disable
> VFs from userspace via SYSFS. At the moment I am not quite clear what
> exactly is supposed to control these capabilities. This could be
> Linux tools or, on a virtualized system, hypervisor control tools.
> One thing I am missing though is an in-kernel API for this which I
> think might be useful. After all the PF driver controls the device,
> and, for example, when a device error occurs (e.g. a hardware failure
> which only the PF driver will be able to detect, not Linux), then the
> PF driver might have to de-allocate all resources, shut down VFs and
> reset the device, or something like that. In that case the PF driver
> needs to have a way to notify the Linux SR-IOV code about this and
> initiate cleaning up of VFs and their resources. At the moment, this
> would have to go through userspace, I believe, and I think that is not
> an optimal solution. Yu, do you have an opinion on how this would be
> realized?

That's a good point, Yu?

-- 
Jesse Barnes, Intel Open Source Technology Center

