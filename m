Return-Path: <linux-kernel-owner+w=401wt.eu-S1758515AbYJGXqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbYJGXqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbYJGXpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:45:49 -0400
Received: from gw.goop.org ([64.81.55.164]:39448 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916AbYJGXps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:45:48 -0400
Message-ID: <48EBF4A7.3080704@goop.org>
Date: Tue, 07 Oct 2008 16:45:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Nakajima, Jun" <jun.nakajima@intel.com>,
       "akataria@vmware.com" <akataria@vmware.com>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Zach Amsden <zach@vmware.com>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [RFC] CPUID usage for interaction between Hypervisors	and	Linux.
References: <1222881242.9381.17.camel@alok-dev1>	 <48E3B19D.6060905@zytor.com> <1222882431.9381.23.camel@alok-dev1>	 <48E3BC21.4080803@goop.org> <1222895153.9381.69.camel@alok-dev1> <48E3FDD5.7040106@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15D927EA4@orsmsx505.amr.corp.intel.com> <48E422CA.2010606@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA221@orsmsx505.amr.corp.intel.com> <48E6AB15.8060405@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DCBA325@orsmsx505.amr.corp.intel.com> <48E6BA5B.2090804@zytor.com> <0B53E02A2965CE4F9ADB38B34501A3A15DE4F934@orsmsx505.amr.corp.intel.com> <48EBE499.5000304@zytor.com>
In-Reply-To: <48EBE499.5000304@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> And you're absolutely right that the guest may end up picking and 
> choosing different parts of the interfaces.  That's how it is supposed 
> to work. 

No, that would be a horrible, horrible mistake.  There's no sane way to 
implement that; it would mean that the hypervisor would have to have 
some kind of state model that incorporates all the ABIs in a consistent 
way.  Any guest using multiple ABIs would effectively end up being 
dependent on a particular hypervisor via a frankensteinian interface 
that no other hypervisor would implement in the same way, even if they 
claim to implement the same set of interfaces.

If the hypervisor just needs to deal with one at a time then it can have 
relatively simple ABI<->internal state translation.

However, if you have the notion of hypervisor-agnostic or common 
interfaces, then you can include those as part of the rest of the ABI 
and make it sane (so Xen+common, hyperv+common, etc).

    J
