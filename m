Return-Path: <linux-kernel-owner+w=401wt.eu-S935035AbZDIO6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035AbZDIO6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZDIO6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:58:21 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:60723 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZDIO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:58:20 -0400
Date: Thu, 9 Apr 2009 09:58:19 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-hotplug@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Network Device Naming mechanism and policy
Message-ID: <20090409145818.GA13155@auslistsprd01.us.dell.com>
References: <20090324154617.GA16332@auslistsprd01.us.dell.com> <20090324.155756.214460004.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324.155756.214460004.davem@davemloft.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 03:57:56PM -0700, David Miller wrote:
> From: Matt Domsch <Matt_Domsch@dell.com>
> Date: Tue, 24 Mar 2009 10:46:17 -0500
> 
> > Problem: Users expect on-motherboard NICs to be named eth0..ethN.
> > This can be difficult to achieve.
> 
> I learned a long time ago that eth0 et al. have zero meaning.
> 
> If the system firmware folks gave us topology information with respect
> to these things, we could export something that tools such as
> NetworkManager, iproute2, etc. could use.
> 
> For example, if we were told that PCI device "domain:bus:dev:fn" has
> string label "Onboard Ethernet 0" then we could present that to the
> user.
> 
> Changing how the actual network device name is determined is going to
> have zero traction.


David, would you be opposed to the additional device names being done
as device nodes in userspace, as several people suggested?

/sys/devices/*/net/ifindex already exports the netlink device index.
It would be trivial to add a /sys/devices/*/net/dev file, with
<major>:<minor> for a device, where <minor> = ifindex.

Then udev could then maintain /dev/net/by-{mac,path,...} as symlinks
to /dev/net/$kernelname.

Tools such as iproute's 'ip' could then be extended to look up their
'dev' argument by /dev path, resolve the symlink to name, get the device node, and
open the socket with the minor number / index (as normal).

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
