Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYBUUiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYBUUiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbYBUUhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:37:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:24052 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759390AbYBUUhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:37:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="382026453"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: kernel-2.6.25-rc2,      CPU C state "active state" always remain C0 unchangeable by cat      'proc/'
Date: Thu, 21 Feb 2008 12:24:23 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE963B7F@orsmsx423.amr.corp.intel.com>
In-Reply-To: <1638.172.16.116.56.1203577279.squirrel@linux.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kernel-2.6.25-rc2,      CPU C state "active state" always remain C0 unchangeable by cat      'proc/'
Thread-Index: Ach0WDL6iGIdk5BaRmehwzcBAPWtugAbciIw
References: <1638.172.16.116.56.1203577279.squirrel@linux.intel.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <youquan_song@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: "Song, Youquan" <youquan.song@intel.com>
X-OriginalArrivalTime: 21 Feb 2008 20:22:55.0123 (UTC) FILETIME=[8A833E30:01C874C7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>youquan_song@linux.intel.com
>Sent: Wednesday, February 20, 2008 11:01 PM
>To: linux-kernel@vger.kernel.org
>Cc: Song, Youquan
>Subject: kernel-2.6.25-rc2, CPU C state "active state" always 
>remain C0 unchangeable by cat 'proc/'
>
>On Fedora9 Alpha with  kernel-2.6.25-rc2,
>I run " watch -n 0.1 "cat /proc/acpi/processor/CPU*/power | 
>grep 'active
>state'" ", I find that the CPU C state information "active 
>state" remain
>at "C0" and it do not change any time. The same issue also exit on
>2.6.24-rc2 kernel.
>But with RHEL5.1 kernel-2.6.18 the CPU C state information is normal.
>
>
>Every 0.1s: cat /proc/acpi/processor/CPU*/power | grep 'active 
>state'     
>                                                               
>         
>Thu Feb 21 09:44:33 2008
>
>active state:            C0
>active state:            C0
>active state:            C0
>active state:            C0
>active state:            C0
>active state:            C0
>active state:            C0
>active state:            C0
>
>On RHEL5.1  kernel-2.6.18-53.el5
>[root@localhost ~]# cat /proc/acpi/processor/CPU*/power | grep 
>'active state'
>active state:            C2
>active state:            C2
>active state:            C2
>active state:            C2
>active state:            C2
>active state:            C3
>active state:            C2
>active state:            C3
>
>The hardware platform: bensley and santarosa.
>

I am not sure active state gives a lot of information about C-state. And
I really hate to see code waking up every .1 sec to check the active
state :-).
/proc/acpi/processor/*/power is marked deprecated upstream and if you
really want this field, you will have to disable CONFIG_CPU_IDLE in
upstream kernel. With CPU_IDLE you will get more detailed information
about all C-states entry counts and residencies under
/sys/devices/system/cpu/cpu*/cpuidle/

Thanks,
Venki
