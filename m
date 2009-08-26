Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZHZRpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZHZRpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZHZRpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:45:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59045 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbZHZRpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:45:07 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Aug 2009 10:45:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090826102908.GA21523@redhat.com>
Message-ID: <alpine.DEB.2.00.0908261040100.7780@makko.or.mcafeemobile.com>
References: <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com> <alpine.DEB.2.00.0908241114501.7951@makko.or.mcafeemobile.com>
 <20090824214900.GA9899@redhat.com> <alpine.DEB.2.00.0908241508440.7951@makko.or.mcafeemobile.com> <20090825072229.GA10608@redhat.com> <alpine.DEB.2.00.0908251456230.18518@makko.or.mcafeemobile.com> <20090826102908.GA21523@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Michael S. Tsirkin wrote:

> On Tue, Aug 25, 2009 at 02:57:01PM -0700, Davide Libenzi wrote:
> > On Tue, 25 Aug 2009, Michael S. Tsirkin wrote:
> > 
> > > Yes, we don't want that. The best thing is to try to restate the problem
> > > in a way that is generic, and then either solve or best use existing
> > > solution. Right?
> > > 
> > > I thought I had that, but apparently not.  The reason I'm Cc-ing you is
> > > not to try and spam you until you give up and accept the patch, it's
> > > hoping that you see the pattern behind our usage, and help generalize
> > > it.
> > > 
> > > If I understand it correctly, you believe this is not possible and so
> > > any solution will have to be in KVM? Or maybe I didn't state the problem
> > > clearly enough and should restate it?
> > 
> > Please do.
> > 
> > 
> > 
> > - Davide
> 
> 
> Problem looks like this:
> 
> There are multiple processes (devices) where each has a condition
> (interrupt line) which it has logic to determine is either true or
> false.
> 
> A single other process (hypervisor) is interested in a condition
> (interrupt level) which is a logical OR of all interrupt lines.
> On changes, an interrupt level value needs to be read and copied to
> guest virtual cpu.
> 
> We also want ability to replace some or all processes above by a kernel
> components, with condition changes done potentially from hardware
> interrupt context.
> 
> 
> How we wanted to solve it with EFD_STATE: Share a separate eventfd
> between each device and the hypervisor.  device sets state to either 0
> or 1.  hypervisor polls all eventfds, reads interrupt line on changes,
> calculates the interrupt level and updates guest.
> 
> Alternative solution: shared memory where each device writes interrupt
> line value. This makes setup more complex (need to share around much more
> than just an fd), and makes access from interrupt impossible unless we
> lock the memory (and locking userspace memory introduces yet another set
> of issues).

OK, if I get it correctly, there is one eventfd signaler (the device), and 
one eventfd reader (the hypervisor), right?
Each hypervisor listens for multiple devices detecting state changes, and 
associating the eventfd "line" to the IRQ number by some configuration 
(ala PCI), right?



- Davide


