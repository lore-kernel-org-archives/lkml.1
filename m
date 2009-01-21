Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZAUSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZAUSNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZAUSNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:13:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:52821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZAUSNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:13:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,301,1231142400"; 
   d="scan'208";a="102393311"
Date: Wed, 21 Jan 2009 10:12:54 -0800 (Pacific Standard Time)
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Ingo Molnar <mingo@elte.hu>
cc: "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: e1000e regression (interface hang) with latest -git
In-Reply-To: <20090121180344.GA13675@elte.hu>
Message-ID: <Pine.WNT.4.64.0901211010250.6372@ppwaskie-MOBL2.amr.corp.intel.com>
References: <20090121102840.GA24967@elte.hu>
 <8DD2590731AB5D4C9DBF71A877482A900DABEA6F@orsmsx509.amr.corp.intel.com>
 <20090121175158.GA7302@elte.hu> <20090121180344.GA13675@elte.hu>
ReplyTo: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
X-X-Sender: amrppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > The same point remains though: it worked before (and works fine with a 
> > distro kernel, 2.6.28-0.140.rc9.git1.fc11.x86_64) and doesnt work with 
> > latest -git.
> > 
> > I'll capture some debug data and send it to you.
> 
> find attached the debug data:
> 
>   ethtool.dump.eth0.before
>   ethtool.dump.eth0.after
>   ethtool.dump.eth0.after2
>   boot.log
>   config
> 
> the 'before' dump is before the hang, shortly after bootup. It also 
> includes 'ifconfig eth0' output.
> 
> the 'after' dump is after the hang - while the interface is hung.
> 
> 'after2' dump is after a 'service network restart' - which brought the 
> interface back.
> 
> Note if i wait long enough (half an hour or so), then not even 'service 
> network restart' will bring back the device.
> 
> The kernel i tested is: v2.6.29-rc2-13-gf3b8436

As Bruce stated, this is an igb issue, not e1000e.  From your boot.log:

igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX

One other piece of info (in addition to what Bruce requested) that would 
be useful is after you've done ifconfig eht0 up, cat /proc/interrupts | 
grep eth0 and send that output (I want to see your MSI-X configuration).

Cheers,
-PJ Waskiewicz
