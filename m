Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbXC0NqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbXC0NqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 09:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbXC0NqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 09:46:19 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:62991 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753857AbXC0NqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 09:46:18 -0400
Subject: Re: oprofile / selinux / security_port_sid
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Sami Farin <safari-kernel@safari.iki.fi>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>
In-Reply-To: <20070327100653.vtmuy64kgkikydlx@m.safari.iki.fi>
References: <20070327100653.vtmuy64kgkikydlx@m.safari.iki.fi>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 27 Mar 2007 09:40:23 -0400
Message-Id: <1175002823.3864.301.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 13:06 +0300, Sami Farin wrote:
> is there room for improvement in security_port_sid() ?

Yes, lots of room.  Also, it won't get called per-packet if you enable
secmark (echo 0 > /selinux/compat_net or boot with selinux_compat_net=0
or build with SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT), although that
may require updating your policy.

> little test with dns queries (dnsfilter (the client) on local host
> using poll() and dnscache (the server) using epoll (at max 4000 concurrent
> queries):
> (stats for only vmlinux)
> 
> CPU: P4 / Xeon, speed 2797.32 MHz (estimated)
> Counted GLOBAL_POWER_EVENTS events (time during which processor is not stopped) with a unit mask of 0x01 (mandatory) count 45000
> Counted FSB_DATA_ACTIVITY events (DRDY or DBSY events on the front side bus) with a unit mask of 0x03 (multiple flags) count 45000
> Counted BRANCH_RETIRED events (retired branches) with a unit mask of 0x05 (multiple flags) count 45000
> Counted BRANCH_RETIRED events (retired branches) with a unit mask of 0x0a (multiple flags) count 45000
> samples  %        samples  %        samples  %        samples  %        symbol name
> 220663   10.2181  6704     17.9737  5735      7.5171  27        1.1989  datagram_poll
> 140086    6.4869  3239      8.6839  3786      4.9624  24        1.0657  sock_poll
> 119636    5.5399  2172      5.8232  7168      9.3954  24        1.0657  do_poll
> 101512    4.7006  3987     10.6893  812       1.0643  14        0.6217  udp_get_port
> 71008     3.2881  1017      2.7266  2694      3.5311  397      17.6288  security_port_sid
> 64350     2.9798  144       0.3861  1912      2.5061  6         0.2664  add_wait_queue
> 60815     2.8161  187       0.5014  3246      4.2546  2         0.0888  remove_wait_queue
> 47456     2.1975  1823      4.8875  476       0.6239  31        1.3766  udp_v4_lookup_longway
> 
> if dnsfilter had used epoll, security_port_sid would
> probably (?) be number one (or two or three) CPU user in kernel.
> 
> also note that 17.6% of mispredicted branches occurr in security_port_sid.
> 
-- 
Stephen Smalley
National Security Agency

