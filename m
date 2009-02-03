Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbZBCUtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbZBCUtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZBCUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:48:56 -0500
Received: from bay0-omc2-s23.bay0.hotmail.com ([65.54.246.159]:22241 "EHLO
	bay0-omc2-s23.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbZBCUsz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:48:55 -0500
Message-ID: <BAY111-W3692AA5F9F7896AA447A1F88C20@phx.gbl>
X-Originating-IP: [171.70.247.31]
From: Krishna Kothapalli <krishna_sunitha@hotmail.com>
To: <kaneshige.kenji@jp.fujitsu.com>
CC: <ebiederm@xmission.com>, <linux-pci@vger.kernel.org>,
       <jbarnes@virtuousgeek.org>, <achiang@hp.com>, <djwong@us.ibm.com>,
       <xyzzy@speakeasy.org>, <linux-kernel@vger.kernel.org>
Subject: RE: Q: state of pci express hotplug
Date: Tue, 3 Feb 2009 15:48:54 -0500
Importance: Normal
In-Reply-To: <49879508.4090801@jp.fujitsu.com>
References: <m1fxj06js8.fsf@fess.ebiederm.org>
 <4986581F.7060704@jp.fujitsu.com>
  <BAY111-W15F61DA9CA66E14686D5F688C50@phx.gbl>
  <49879508.4090801@jp.fujitsu.com> 
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Feb 2009 20:48:55.0017 (UTC) FILETIME=[D4092D90:01C98640]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Kenji Kaneshige wrote:
> (1) Build all your hotplug drivers as kernel modules.
> (2) Modprobe hotplug drivers one by one, and check which drivers add
> directories under /sys/bus/pci/slots. Before trying the next driver,
> please rmmod the previous driver, because there are hotplug slots
> that can be managed by the several drivers. Note that you don't need
> to try fakephp this time.
>

Thanks much for the exact steps. Here are the results. Pls let me know if you want me to run them on a different branch or other steps.

Built the kernel with these options:-

CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

# uname -a
Linux localhost.localdomain 2.6.25-14.fc9.x86_64.kkhp #4 SMP Tue Feb 3 11:12:07 PST 2009 x86_64 x86_64 x86_64 GNU/Linux


[root@localhost linux-2.6.25.x86_64]#ls -lt /sys/bus/pci/slots
total 0
[root@localhost linux-2.6.25.x86_64]# /sbin/modprobe acpiphp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-03 11:32 2
[root@localhost linux-2.6.25.x86_64]# /sbin/rmmod acpiphp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
[root@localhost linux-2.6.25.x86_64]# /sbin/modprobe pciehp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
drwxr-xr-x 2 root root 0 2009-02-03 11:33 0009_0096
[root@localhost linux-2.6.25.x86_64]# /sbin/rmmod pciehp
[root@localhost linux-2.6.25.x86_64]# /sbin/modprobe shpchp
[root@localhost linux-2.6.25.x86_64]# ls -lt /sys/bus/pci/slots
total 0
[root@localhost linux-2.6.25.x86_64]# /sbin/rmmod shpchp
[root@localhost linux-2.6.25.x86_64]# 


Thanks,
Krishna


_________________________________________________________________
Windows Live™: E-mail. Chat. Share. Get more ways to connect. 
http://windowslive.com/explore?ocid=TXT_TAGLM_WL_t2_allup_explore_012009