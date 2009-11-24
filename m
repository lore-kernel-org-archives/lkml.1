Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbZKXLTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbZKXLTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932773AbZKXLTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:19:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:1146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbZKXLTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:19:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=iKV+O20/2oJY+LWVgm+6PTHVLCZU4MqfR2TWZt+hh6ZlqP3C7/v6wu5HTqDesuomVL
         V4yrTbzWuyR0QCm66JBpLBtExqWBGdxYBcC8zoVhi16g1aqyyun0qc8t98SL6ttGwW0M
         VkUpZ9QQqglWCWRviJPRo4CicAOQ5Xf7He9jM=
Date: Tue, 24 Nov 2009 11:19:46 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091124111946.GA7883@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 01:17:09AM -0500, Caleb Cushing wrote:
> > Btw, currently I don't consider this dropping means there has to be
> > a bug. It could be otherwise - a feature... e.g. when a new kernel
> > can transmit faster (then dropping in some other, slower place can
> > happen).
> 
> um... where would it be dropping that we wouldn't have a bug? I mean
> sure faster is great... but if it makes my network not work right...

E.g. if it were dropped because of a queue overflow (but it doesn't
seem to be the case, at least at your box) or because of memory
problems while handling a lot of traffic.

> 
> I've added all (I think) information you've asked for to the bug
> http://bugzilla.kernel.org/show_bug.cgi?id=13835 except for ethtool
> and netstat on the router side. ethtool complains about not having
> driver or capability (maybe because it's a 2.4 kernel?) and the
> version of netstat doesn't support -s. I disabled everything that I
> can think of that would send/receive packets before doing the test
> client side, except dhcp/dns windows box's were probably sending some
> broadcasts too. but the traffic should be pretty low. I did remember
> to set the txqueuelen didn't seem to make a difference

Alas it's not all information I asked. E.g. "netstat -s before faulty
kernel" and "netstat -s after faulty kernel" seem to be the same file:
netstat_after.slave4.log.gz. Anyway, since there are problems with
getting stats from the router we still can't compare them, or check
for the dropped stats. (Btw, could you check for /proc/net/softnet_stat
yet?)

So, it might be the kernel problem you reported, but there is not
enough data to prove it. Then my proposal is to try to repeat this
problem in more "testing friendly" conditions - preferably against
some other, more up-to-date linux box, if possible?

> only error in dmesg I see is
> 
> e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb

I added e1000e maintainers to CC to have a look at this warning.

Jarek P.
