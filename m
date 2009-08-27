Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949AbZH0Ltc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbZH0Ltc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 07:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZH0Ltb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 07:49:31 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:47305 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZH0Lta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 07:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=gkYpDA4b0CiomgF2Evd15MsD4iQ4wdRvav8bRg2pk29UZs/UDrRqoQOOcEH6+jv2aP
         ym6i9yHThfRMasiXR4i7DjnAvgchngte1Ynbm3+AXrICdDYgf6JcaYUjp7fJwBq2xui0
         KcDIwcOBi0msricnyApiXZgaLa5GVGtyn7tjc=
MIME-Version: 1.0
Date: Thu, 27 Aug 2009 19:49:32 +0800
Message-ID: <664902dd0908270449x24f3ee12k615540ffe22e5b58@mail.gmail.com>
Subject: (Re)assignment of PCI BARs
From: Beng Tan <bengtan1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an issue relating to allocation of PCI resources in the kernel.
My brief question is ... how do I get the kernel to reassign PCI
resources (if that's not already automatic) and/or is it possible to
explicitly reassign a single BAR of a PCI device?

However, my understanding may be incomplete and this question may not
make sense to those who know the kernel better. So, here's some
background.

-- Start background --

I've connected an external PCI Express card to my laptop, but I am
having PCI resource allocation issues.

I have a PE2L (see http://www.hwtools.net/Adapter/PE2L.html)
connecting my laptop's Express Card slot to a Gigabyte ATI Radeon HD
4550. I got the idea from a DIY Vidock thread (see
http://forum.notebookreview.com/showthread.php?t=397667), and the PE2L
is apparently the same as a ViDock2 (see
http://www.villagetronic.com/vidock2/index.html).

My laptop is a Dell 640m (with integrated Intel graphics), and I'm
trying to find a way to hook up 2 external monitors without having to
buy a new system. Hence the external graphics card idea.

-- End background --

The symptom I'm seeing is that the card has BAR 0 unassigned ...

  Region 0: Memory at <unassigned> (64-bit, prefetchable) [disabled]

and indeed, the kernel reports this through dmesg ...

[    6.147093] PCI: Failed to allocate mem resource
#0:10000000@e0000000 for 0000:0d:00.0

Full logs are available at:

http://208.100.55.9/coldboot_20090827/dmesg.txt
http://208.100.55.9/coldboot_20090827/iomem.txt
http://208.100.55.9/coldboot_20090827/lspci_vv.txt

Doesn't the kernel reassign PCI resources if the BIOS doesnt do a good
enough job? Or is that not the case in my old kernel (2.6.24)?

Is it possible to force a reassignment of the impacted BAR? For
example, I wrote a small module which wrote to the device's PCI
configuration registers to explcitly reassign BAR 0 to 0xc00000000
(and also bit bashed the connecting bridge to do the same) but ... I'm
not sure if I'm doing it correctly.

I believe the hardware is working fine. X was able to find out about a
monitor attached to the device, but that is all.

And, for reference, you can see someone else's lspci output of the
same card in the first post of
http://ubuntuforums.org/archive/index.php/t-1215318.html.

So, any thoughts for things I can try to diagnose this? Should I try
compiling and running a bleeding edge kernel?

Thank you. Any help is much appreciated.

Beng Tan

ThinkLeft
