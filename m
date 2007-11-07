Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbXKGUjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbXKGUjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXKGUjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:39:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:63259 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbXKGUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=usl8KtHZ6l3QnDZ84PeICsM3QFMxHXNDEPeColi3dgAN6kMpPLNfhuwjNXXTc1FyF+cHBxWS+LKcJ9aSdQZ3xLLLG+Ck/KyqRcuL2OP/RT4Ow9oI2dJKw6QJDWCdCikG6brk6ZkvC20WqWve2UfKYHzF8hB+VzayCpux3wyBna0=
Message-ID: <47322262.8000101@gmail.com>
Date: Wed, 07 Nov 2007 15:38:58 -0500
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com>
In-Reply-To: <47314FBD.1070505@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> 
> I dislike strings.  They make it look as if you have a nice extensible
> interface, where in reality you have a poorly documented interface which
> leads to poor interoperability.

Its not really a full fledged interface, but rather just a simple id
mechanism.  A decentralized id mechanism with less administrative burden.

On the flip side, a centralized namespace has the advantage of
controlling collisions at the expense of administrative overhead.  After
designing systems both ways in the past, I prefer to reduce the admin
burden, but that is just me.


> PCI means that you can reuse all of the platform's infrastructure for
> irq allocation, discovery, device hotplug, and management.

Its tempting to use, yes.  However, most of that infrastructure is
completely inappropriate for a PV implementation, IMHO.  You are
probably better off designing something that is PV specific instead of
shoehorning it in to fit a different model (at least for the things I
have in mind).  Its not a heck of a lot of code to write a pv-centric
version of these facilities.

> You can write it for new guests but backporting it to older guests will be a
> huge task.
> 
> We will support non-pci for s390, but in order to support Windows and
> older Linux PCI is necessary.

I don't know if I would agree with "necessary".  "Easier" perhaps. ;) By
definition once you are PV you are hypervisor aware.  Now its just a
matter of plugging in the appropriate plumbing to bridge the hypervisor
to the guest-os.  Some might be easier than others, sure.  But all
should be extensible to a degree.

But I digress.  I haven't really had much of a chance to follow the
latest developments here as I have been lost in -rt land for a few
months now.  But I know Anthony and Rusty are top-notch, so I'm sure you
guys have it under control.  Hopefully, one day soon I will be able to
join you guys again (perhaps to the KVM team's dismay ;).

Regards,
-Greg


