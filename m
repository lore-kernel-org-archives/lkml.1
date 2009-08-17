Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZHQK4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZHQK4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 06:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZHQK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 06:56:11 -0400
Received: from mga06.intel.com ([134.134.136.21]:15705 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751051AbZHQK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 06:56:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,395,1246863600"; 
   d="scan'208";a="439580436"
Message-ID: <4A893746.4040402@linux.intel.com>
Date: Mon, 17 Aug 2009 12:56:06 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       Yinghai Lu <yinghai@kernel.org>, Huang Ying <ying.huang@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine	check
 code on 32bit
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu> <4A891E17.1090901@jp.fujitsu.com>
In-Reply-To: <4A891E17.1090901@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> One possibility is: if the BIOS doesn't clear status in banks,
> new mce codes will try to log such junks.
> If the junk is totally junk but can be decoded as a valid log with
> MISCV or ADDRV bit, and if the cpu try to access register which is
> not implemented (e.g. IA32_MCi_MISC/ADDR), then such access might
> cause a general protection exception. (ref. ASDM 3A 15.3.2.3)

The MCA declares if it comes with ADDR or MISC in a status bit
and the MCA code only accesses these MSRs if these status bits are set.
Also I believe P3 implemented ADDR at least, likely even MISC.

The old 32bit MCA code did that too

-Andi
