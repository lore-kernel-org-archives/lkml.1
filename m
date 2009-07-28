Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbZG1Uh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbZG1Uh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZG1Uh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:37:27 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:51735 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZG1Uh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:37:26 -0400
Date: Tue, 28 Jul 2009 22:37:24 +0200
Message-Id: <843616099@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: zamsden@redhat.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow userspace block device implementation
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/zPN3Un63OG1zRiscOETij7PY8ZiCXxjDGXrjvBmW5AkVKE
 kHb2l9T77kMEChQhxqCdQyxy66XjnQsgvajy18IF4MeiHdTRzM=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Zach, 

this older thread deals with some aspects of that idea: http://communities.vmware.com/message/577841
i have collected some links (added there) quite a while ago and also added a project proposal to http://kernelnewbies.org/KernelProjects, too.
i don`t know if you came across them, but it`s nice to see that someone comes up with this stuff again and maybe it`s of interest for you.

as we had vmware vmdk image mounter v1 being implemented via nbd and v2 via fuse, i assume both are not optimal solutions?
at least the nbd version sucked big. 

regards
roland

ps:
oh, btw - you quit vmware? that`s quite a loss for them and for the vmware community, i think.  too much conflicting basic attitude concerning opensource/gpl? ;)



> List:       linux-kernel
> Subject:    [PATCH] Allow userspace block device implementation
> From:       Zachary Amsden <zamsden () redhat ! com>
> Date:       2009-07-27 9:57:10
> Message-ID: 4A6D79F6.3050509 () redhat ! com
> [Download message RAW]
> 
> Well, it may be a good, bad, idiotic or brilliant idea depending on your
> personal philosophy.  I went down this route out of pragmatism.
> Hopefully I have not fully re-invented the wheel.
> 
> The patch included allows one to implement a kernel level block device
> in userspace, using an ioctl() based interface to create a sized device
> with given properties, and then receive and respond to bio requests
> issued to the device.  One can poll on the associated control socket to
> allow efficient servicing of device requests.  So far only strict copy
> to/from user memory is supported, there is no fancy page flipping or
> mapping operations.
> 
> Which there probably should not be.  This device is not about
> performance, is it about extending the boundaries of the kernel to the
> almost improbable.  Now one can literally create any kind of device
> imaginable and use it as a block device in the kernel, mounting
> partitions and such and using them as if they existed natively.  I have
> attached a very simple dummy program showing how to do this.
> 
> The design requirements 'kernel block device in user space' to me
> demanded that the interface be stateless.  Userspace can crash, be
> killed, or interrupted.  Block devices cannot, they must answer all
> requests, even if that answer is a failure.  Thus there exists no state
> between the kernel and the userspace process(es) or threads serving the
> device.  No establishment of connections, just a queue which can be read
> and answered via get and put, the ioctl operators available.  This
> allows a completely flexible userspace implementation, with multiple
> processes, etc, and allows complete recovery via a simple reset command
> if those programs fail.  I believe this also prevents any possibility of
> accidental deadlock.  There may of course be some hidden deep deadlock
> potential in such a device, especially if one decided to use it as a
> swap device, but again, this is a philosophical issue.
> 
> Enough talking, let's have at it and see where this goes.  Obviously
> this is experimental and open to feedback.  Considering it turns kernel
> interfaces on their head, I have given it what I feel is an appropriate
> name.
> 
> If there is any person or list you know that I forgot to copy this to,
> please forward it on to them.
> 
> Thanks,
> 
> Zach
> 
> _________________________________________________________________
> Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate 
> für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/01/
> 
> 


______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

