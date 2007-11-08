Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbXKHGh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbXKHGh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXKHGhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:37:19 -0500
Received: from il.qumranet.com ([82.166.9.18]:57097 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXKHGhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:37:18 -0500
Message-ID: <4732AE9A.4070701@qumranet.com>
Date: Thu, 08 Nov 2007 08:37:14 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
CC: Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com> <47322262.8000101@gmail.com>
In-Reply-To: <47322262.8000101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Thu, 08 Nov 2007 08:37:14 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
>
>> PCI means that you can reuse all of the platform's infrastructure for
>> irq allocation, discovery, device hotplug, and management.
>>     
>
> Its tempting to use, yes.  However, most of that infrastructure is
> completely inappropriate for a PV implementation, IMHO.  

Why?

> You are
> probably better off designing something that is PV specific instead of
> shoehorning it in to fit a different model (at least for the things I
> have in mind).  

Well, if we design our pv devices to look like hardware, they will fit
quite well.  Both to the guest OS and to user's expectations.

> Its not a heck of a lot of code to write a pv-centric
> version of these facilities.
>
>   

It is.  Especially if you consider Windows and a gazillion versions of
deployed, non-pv-capable Linux systems.  For pv-friendly newer Linux,
it's probably doable, but why?

Look at the mess Xen finds itself in.

>> You can write it for new guests but backporting it to older guests will be a
>> huge task.
>>
>> We will support non-pci for s390, but in order to support Windows and
>> older Linux PCI is necessary.
>>     
>
> I don't know if I would agree with "necessary".  "Easier" perhaps. ;) By
> definition once you are PV you are hypervisor aware.  Now its just a
> matter of plugging in the appropriate plumbing to bridge the hypervisor
> to the guest-os.  Some might be easier than others, sure.  But all
> should be extensible to a degree.
>
>   

It's "necessary" in a pragmatic sense: we want to deliver drivers that
provide features for a wide variety of guests in a reasonable
timeframe.  And that means no rewriting guest OS infrastructure.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

