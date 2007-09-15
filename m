Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXIOA2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXIOA2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXIOA2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:28:10 -0400
Received: from gw.goop.org ([64.81.55.164]:51258 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbXIOA2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:28:09 -0400
Message-ID: <46EB2716.1070908@goop.org>
Date: Fri, 14 Sep 2007 17:28:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com>
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nakajima, Jun wrote:
> Today, 3 CPUID leaves starting from 0x4000_0000 are defined in a generic
> fashion (hypervisor detection, version, and hypercall page), and those
> are the ones used by Xen today. We should extend those leaves (e.g.
> starting from 0x4000_0003) for the vmm-independent features as well.
>
> If Xen needs additional Xen-specific features, we need to allocate some
> leaves for those (e.g. 0x4000_1000)

But the signature is "XenVMMXenVMM", which isn't very generic.  If we're
presenting a generic interface, it needs to have a generic signature,
otherwise guests will need to have a list of all hypervisor signatures
supporting their interface.  Since 0x40000000 has already been
established as the base leaf of the hypervisor-specific interfaces, the
generic interface will have to be elsewhere.

    J
