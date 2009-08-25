Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZHYAKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZHYAKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHYAKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:10:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:26129 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZHYAKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:10:24 -0400
Message-ID: <4A932BEF.5080603@codemonkey.ws>
Date: Mon, 24 Aug 2009 19:10:23 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: alacrityvm-devel@lists.sourceforge.net, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: vbus design points: shm and shm-signals
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A870964.9090408@codemonkey.ws> <4A8965E0.8050608@gmail.com> <4A89FF08.30509@codemonkey.ws> <4A8AA9BD.2070909@gmail.com> <4A8AB076.6080906@redhat.com> <4A8ACE1F.6020402@gmail.com> <20090818161434.GA15884@elte.hu> <4A8B7F17.6050100@gmail.com> <4A8E7D32.8040209@gmail.com> <4A92E3B1.5080002@codemonkey.ws> <4A92F158.9050003@gmail.com> <4A9328E3.3060106@codemonkey.ws>
In-Reply-To: <4A9328E3.3060106@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> IOW, I can envision a model that looked like PCI -> virtio-pci -> 
> virtio-shm -> virtio-ring -> virtio-net

Let me stress that what's important here is that devices target either 
virtio-ring or virtio-shm.  If we had another transport, those drivers 
would be agnostic toward it.  We really want to preserve the ability to 
use all devices over a PCI transport.  That's a critical requirement for us.

The problem with vbus as it stands today, is that it presents vbus -> 
virtio-ring -> virtio-net and allows drivers to target either 
virtio-ring or vbus directly.  If a driver targets vbus directly, then 
the driver is no longer transport agnostic and we could not support that 
driver over PCI.

Regards,

Anthony Liguori
