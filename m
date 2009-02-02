Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZBBCTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZBBCTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 21:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZBBCTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 21:19:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59155 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZBBCTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 21:19:21 -0500
Message-ID: <4986581F.7060704@jp.fujitsu.com>
Date: Mon, 02 Feb 2009 11:19:11 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       Alex Chiang <achiang@hp.com>, djwong@us.ibm.com,
       Trent Piepho <xyzzy@speakeasy.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
References: <m1fxj06js8.fsf@fess.ebiederm.org>
In-Reply-To: <m1fxj06js8.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Trying to use the current pciehp code, on real hardware in an 
> interesting topology (more later) I'm not finding it very satisfactory
> at all.  I am up to at least three show stopper bugs and the code
> is not doing what I really need it to do, so I am looking at a significant
> rewrite patch effort to make this code usable.
>

I'd like to know details of the bugs. Could you please show the
details of the bugs?

> Am I unique in thinking there is a lot that needs to be done?
> Is there current work in progress to make the pci hotplug work better?
> 

In my personal opinion, there are at least the following items need to
be done for pciehp.

o Possible bugs
  -Current pcie_isr function (interrupt service routine of pciehp) has
   a possibility to get into endless loop in the case that bits in Slot
   Status register is set again immediately after cleared. According to
   the past discussion in the pcihpd-discuss ML, this can happen on the
   power fault detected bit on some platforms.

  -Current pciehp disables software notification of adapter presence
   changed event and MRL changed event when slot is turned off. Because
   of this, there is no way to detect those events on empty slots in the
   current pciehp implementation.

o Missing Features
  -Current pciehp doesn't support Data Link Layer State Changed event
   software notification.
  -No event notification mechanism to userland.
  -When hot-removal request is initiated through the Attention Button
   press, there is no chance to prepare hot-removal (unmount for example).
  -Userland utilities.

o Cleanups
  -slot list is not needed because there is only one slot under the
   switch downstream port.
  -hpc_ops is redundant.
  -some fields in the struct controller, struct slot are redundant.

o Misc
  -I don't think power fault management routines are well tested.
  -I don't think EMI management routines are well tested.

Thanks,
Kenji Kaneshige


