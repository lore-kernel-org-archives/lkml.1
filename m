Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbXHCVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbXHCVOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 17:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbXHCVOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 17:14:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbXHCVOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 17:14:03 -0400
Message-ID: <46B39A8F.5070809@redhat.com>
Date: Fri, 03 Aug 2007 17:13:51 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dynamic major/minor numbers (or dropping them completely)
References: <46B21833.600@aladin.ro>
In-Reply-To: <46B21833.600@aladin.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu wrote:
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> Currently, the kernel has the following properties:
> 1) initramfs can be used to boot the system. We don't need any 
> predefined /dev entries.
> 2) udev can be started from the initramfs to create the required entries 
> in /dev. udev doesn't care about major/minor numbers.
> 3) Most distros already use udev and maybe initramfs. If there are 
> exceptions, they can be easily converted.
> 
> For the first part, I'm asking: is there any reason why new char/block 
> drivers shouldn't use dynamic major/minor numbers? Is there any reason 
> against converting the whole kernel to dynamic major/minor numbers?
> 
> Okay, maybe the previous questions looked useless from a pragmatic POV. 
> But why shouldn't the whole major/minor numbering system be dropped 
> completely? sysfs already maintains a hierachy of device drivers and 
> kernel subsystems, one which is better than the major/minor system. The 
> current system could be replaced by a single-numbered, 
> dynamically-allocated scheme.
> 
> Device files could be stored on a tmpfs filesystem, so that we don't 
> make any changes to current filesystems. Apps won't need to be modified, 
> since they access /dev entries by name, provided udev maintains the 
> current naming scheme.
> 
> Any thoughts on this?

You're correct that dynamic major/minor numbers are sufficient for most 
purposes, but embedded users really need their static numbers.  As for ripping 
out major/minor numberings, that's a non-starter.  Too much of our device 
management infrastructure is based around this numbering scheme, and there isn't 
really anything wrong with it to justify breaking everything in the change.

As a rule of thumb, if you ever find yourself wondering why we still support 
doing statically something we can now do dynamically, the answer is generally 
that doing it dynamically sucks for embedded.

	-- Chris
