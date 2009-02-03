Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZBCAvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZBCAvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZBCAva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:51:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47051 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZBCAv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:51:29 -0500
Message-ID: <49879508.4090801@jp.fujitsu.com>
Date: Tue, 03 Feb 2009 09:51:20 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Krishna Kothapalli <krishna_sunitha@hotmail.com>
CC: ebiederm@xmission.com, linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       achiang@hp.com, djwong@us.ibm.com, xyzzy@speakeasy.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: state of pci express hotplug
References: <m1fxj06js8.fsf@fess.ebiederm.org> <4986581F.7060704@jp.fujitsu.com> <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
In-Reply-To: <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krishna Kothapalli wrote:
> 
>> I'd like to know details of the bugs. Could you please show the
>> details of the bugs?
> 
> Not sure if this is a bug or error on my part:
> 
> a) Cold plug of the PCI express card looks ok ( the devices show up is the sysfs ). 
> b)
> However hotplug of the same device does not work (it won't show up in
> the sysfs and uevents are not sent to udev ). Same issue when ACPI is removed from the kernel build and
> modprobe pciehp pciehp_force=1
> 
> Posted some details in (can send in more details if needed) :
> http://article.gmane.org/gmane.linux.kernel.pci/2865
> http://article.gmane.org/gmane.linux.kernel.pci/2868
> 

In the beginning, I'd like to know which hotplug controller driver
manages your hotplug slots. Could you tell me which hotplug controller
drivers add the directories under /sys/bus/pci/slots, with the following
steps?

  (1) Build all your hotplug drivers as kernel modules.
  (2) Modprobe hotplug drivers one by one, and check which drivers add
      directories under /sys/bus/pci/slots. Before trying the next driver,
      please rmmod the previous driver, because there are hotplug slots
      that can be managed by the several drivers. Note that you don't need
      to try fakephp this time. 

Here is an example. My machine has four hotplug slots and those can be
handled by acpiphp or pciehp. I tried acpiphp, pciehp and shpchp on that
machine.

# ls /sys/bus/pci/slots/
# /sbin/modprobe acpiphp
# ls /sys/bus/pci/slots/
1  2  3  4
# /sbin/rmmod acpiphp
# ls /sys/bus/pci/slots/
# /sbin/modprobe pciehp
# ls /sys/bus/pci/slots/
1  2  3  4
# /sbin/rmmod pciehp
# ls /sys/bus/pci/slots/
# /sbin/modprobe shpchp
# ls /sys/bus/pci/slots/

Thanks,
Kenji Kaneshige

