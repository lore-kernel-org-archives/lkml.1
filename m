Return-Path: <linux-kernel-owner+w=401wt.eu-S1758365AbYBOSRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365AbYBOSRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYBOSRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:17:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:27294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbYBOSRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:17:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,359,1199692800"; 
   d="scan'208";a="519293018"
Message-ID: <47B5D6EB.5010203@intel.com>
Date: Fri, 15 Feb 2008 10:16:11 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <47B5BDC0.3020003@intel.com> <E1JQ3cu-0005ZW-7k@pomaz-ex.szeredi.hu> <47B5C38A.5000909@intel.com> <E1JQ4ik-0005iq-NH@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JQ4ik-0005iq-NH@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2008 18:17:01.0168 (UTC) FILETIME=[F586AF00:01C86FFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
>> OK. can you download, install and run `ethregs -i eth0` (from
>> e1000.sf.net) and send me the output? I'll compare with a known
>> working t60 I have here and see if anything shows up.
> 
> OK, attached.
> 
>> Also, post me the dmesg from after the adapter fails to load
>> properly.
> 
> Hmm, nothing in dmesg.  Looking at syslog, I'm not even sure it's a
> driver issue, it could also be dhclient or NetworkManager bug.  The
> strange thing is that this only happens on -mm.
> 
> These are the relevant syslog messages for an unsuccessful attempt:
> 
> ==========================================================================
> Feb 15 12:27:32 tucsk kernel: [   35.169183] 0000:02:00.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
> Feb 15 12:27:32 tucsk kernel: [   35.169190] 0000:02:00.0: eth0: 10/100 speed: disabling TSO
> Feb 15 12:27:40 tucsk dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 4
> Feb 15 12:27:40 tucsk dhclient: DHCPOFFER from 192.168.0.1
> Feb 15 12:27:45 tucsk dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
> Feb 15 12:27:45 tucsk dhclient: DHCPACK from 192.168.0.1
> Feb 15 12:27:46 tucsk dhclient: bound to 192.168.0.9 -- renewal in 1539 seconds.
> Feb 15 12:28:20 tucsk dhclient: caught deadly SIGTERM
> Feb 15 12:28:20 tucsk dhclient: could not restore resolv.conf: No such file or directory
> Feb 15 12:28:20 tucsk dhclient: DHCPRELEASE on eth0 to 192.168.0.1 port 67
> Feb 15 12:28:20 tucsk dhclient: send_packet: Network is unreachable
> Feb 15 12:28:20 tucsk dhclient: send_packet: please consult README file regarding broadcast address.
> ==========================================================================
> 
> And then for the successful one:
> 
> ==========================================================================
> Feb 15 12:29:17 tucsk dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 2
> Feb 15 12:29:17 tucsk dhclient: DHCPOFFER from 192.168.0.1
> Feb 15 12:29:22 tucsk dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
> Feb 15 12:29:22 tucsk dhclient: DHCPACK from 192.168.0.1
> Feb 15 12:29:22 tucsk dhclient: bound to 192.168.0.9 -- renewal in 1543 seconds.
> ==========================================================================
> 
> Thanks,
> Miklos
> 
> 
> 
> 02:00.0 (8086:109a)
> Unknown device 8086:109a
> 	Name           Value
> 	~~~~           ~~~~~
> 	CTRL           18140248

the register dump looks OK as far as I can see. Since initialization works OK and
the adapter seems to be setup OK reading from the register dump, I'm not sure at
all what is going on.

can you try manually ifup-ing the device and running tcpdump? do you see packets
coming in?

just for kicks, have you tried a different cable? or is the adapter consistently
working properly using a different kernel/driver?

Auke
