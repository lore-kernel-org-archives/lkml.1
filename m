Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbZE1AtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbZE1AtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZE1AtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:49:16 -0400
Received: from claw.goop.org ([74.207.240.146]:58012 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZE1AtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:49:16 -0400
Message-ID: <4A1DDF8B.6020000@goop.org>
Date: Wed, 27 May 2009 17:49:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, Avi Kivity <avi@redhat.com>,
       George Dunlap <George.Dunlap@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <4A1C3453.6080402@redhat.com> <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu>
In-Reply-To: <20090528001350.GD26820@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> I also find it pretty telling that you cut out the most important 
> point of Avi's reply:
>
>   
>>> I think the Xen design has merit if it can truly make dom0 a 
>>> guest -- that is, if it can survive dom0 failure.  Until then, 
>>> you're just taking a large interdependent codebase and splitting 
>>> it at some random point, but you don't get any stability or 
>>> security in return.
>>>       
>
> that crucial question really has to be answered honestly and 
> upfront.

Xen, the hypervisor itself, doesn't require any services from dom0. From 
its perspective, dom0 is just another guest domain, though with enough 
privileges to access hardware.  Dom0's job is to provide device access 
to other less privileged domains.

There is currently some system-wide information which is stored in a 
usermode daemon in dom0. Recovering from its loss is hard, but there is 
a prototype to pull that daemon out into its own special-purpose 
domain.  At that point, dom0 can reboot without affecting any of the 
other domains or Xen itself.

If dom0 goes away, the other domains will get a disconnect and 
temporarily lose access to their devices, but they can cope with that.  
 From their perspective, it would look like they'd just been 
save/restored or migrated to another machine.  When dom0 comes back, 
they'll reconnect and carry on.

The disaggregation of dom0's functions is something that the Xen 
development community is actively perusing.

    J
