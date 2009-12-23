Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbZLWW64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbZLWW64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZLWW6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:58:54 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:55724 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZLWW6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:58:51 -0500
Message-ID: <4B32A09D.30400@codemonkey.ws>
Date: Wed, 23 Dec 2009 16:58:37 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: Kyle Moffett <kyle@moffetthome.net>,
       Gregory Haskins <gregory.haskins@gmail.com>, kvm@vger.kernel.org,
       netdev@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Alacrityvm-devel] [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <20091218215107.GA14946@elte.hu> <4B2F9582.5000002@gmail.com> <20091222075742.GB26467@elte.hu> <4B3103B4.4070708@gmail.com> <f73f7ab80912222215i39ba865dv95764f95fd57bd96@mail.gmail.com> <4B3232A1.8050505@codemonkey.ws> <20091223195413.GB30700@ovro.caltech.edu>
In-Reply-To: <20091223195413.GB30700@ovro.caltech.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 01:54 PM, Ira W. Snyder wrote:
> On Wed, Dec 23, 2009 at 09:09:21AM -0600, Anthony Liguori wrote:

> I didn't know you were interested in this as well. See my later reply to
> Kyle for a lot of code that I've written with this in mind.


BTW, in the future, please CC me or CC 
virtualization@lists.linux-foundation.org.  Or certainly kvm@vger.  I 
never looked at the virtio-over-pci patchset although I've heard it 
referenced before.

>> But both virtio-lguest and virtio-s390 use in-band enumeration and
>> discovery since they do not have support for PCI on either platform.
>>
>
> I'm interested in the same thing, just over PCI. The only PCI agent
> systems I've used are not capable of manipulating the PCI configuration
> space in such a way that virtio-pci is usable on them.

virtio-pci is the wrong place to start if you want to use a PCI *device* 
as the virtio bus. virtio-pci is meant to use the PCI bus as the virtio 
bus.  That's a very important requirement for us because it maintains 
the relationship of each device looking like a normal PCI device.

> This means
> creating your own enumeration mechanism. Which sucks.

I don't think it sucks.  The idea is that we don't want to unnecessarily 
reinvent things.

Of course, the key feature of virtio is that it makes it possible for 
you to create your own enumeration mechanism if you're so inclined.

> See my virtio-phys
> code (http://www.mmarray.org/~iws/virtio-phys/) for an example of how I
> did it. It was modeled on lguest. Help is appreciated.

If it were me, I'd take a much different approach.  I would use a very 
simple device with a single transmit and receive queue.  I'd create a 
standard header, and the implement a command protocol on top of it. 
You'll be able to support zero copy I/O (although you'll have a fixed 
number of outstanding requests).  You would need a single large ring.

But then again, I have no idea what your requirements are.  You could 
probably get far treating the thing as a network device and just doing 
ATAoE or something like that.

Regards,

Anthony Liguori

> Ira

