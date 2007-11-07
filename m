Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXKGFkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXKGFkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbXKGFkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:40:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:36985 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765AbXKGFkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:40:15 -0500
Message-ID: <47314FBD.1070505@qumranet.com>
Date: Wed, 07 Nov 2007 07:40:13 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
CC: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com> <4731334A.6090405@gmail.com>
In-Reply-To: <4731334A.6090405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 07 Nov 2007 07:40:14 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Anthony Liguori wrote:
>
>   
>> Right now, we would have to have every PCI vendor/device ID pair in the
>> virtio PCI driver ID table for every virtio device.
>>     
>
> I realize you guys are probably far down this road in the design
> process,

That doesn't mean we can't change it if it's wrong.

>  but FWIW: This is a major motivation for the reason that the
> IOQ stuff I posted a while back used strings for device identification
> instead of a fixed length, centrally managed namespace like PCI
> vendor/dev-id.  Then you can just name your device something reasonably
> unique (e.g. "qumranet::veth", or "ibm-pvirt-clock").
>   

I dislike strings.  They make it look as if you have a nice extensible
interface, where in reality you have a poorly documented interface which
leads to poor interoperability.

I prefer nice structure where you can see all the limitations immediately.

> (I realize that if you are going to do PCI, you need to make it
> PCI-like.  But I think using PCI in the first place is probably the
> wrong direction.  IMHO, there's really not a lot of reason to be
> constrained by a hardware specification once you decide to go PV.  This
> is even more true if you want to support as many platforms as possible
> (i.e. platforms that don't have PCI natively).
>
>   

PCI means that you can reuse all of the platform's infrastructure for
irq allocation, discovery, device hotplug, and management.  You can
write it for new guests but backporting it to older guests will be a
huge task.

We will support non-pci for s390, but in order to support Windows and
older Linux PCI is necessary.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

