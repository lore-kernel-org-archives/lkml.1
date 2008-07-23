Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYGWVuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYGWVuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYGWVtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:49:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35277 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYGWVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:49:53 -0400
Date: Wed, 23 Jul 2008 17:49:38 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
Message-ID: <20080723214938.GA8034@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <E1KLm0c-0002O6-RO@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KLm0c-0002O6-RO@closure.thunk.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 05:36:30PM -0400, Theodore Ts'o wrote:
> 
> Is this a new one?  I don't think I've seen this on LKML....

The context of this was I had just booted to 2.6.26-git9, noted with
annoyance that that the iwl4965 driver needed a new microcode file, so
I popped in my EVDO card, downloaded the firmware, moved the firmware
into place, and then got the above error message.

I've since noted that it seems to be utterly refusing to associate
with my wireless access point.  This was working just fine with
2.6.26-git6 kernel, so it looks like a recent regression?  I just
noticed someone else had recently complained about a similar "refusal
to associate" with the iwl3945 driver.

       	      	    	       	    	    - Ted

> 
> [  728.456792] 
> [  728.456795] =============================================
> [  728.456810] [ INFO: possible recursive locking detected ]
> [  728.456818] 2.6.26-05781-g44ea66a #25
> [  728.456823] ---------------------------------------------
> [  728.456830] NetworkManager/8287 is trying to acquire lock:
> [  728.456836]  (&dev->addr_list_lock){-...}, at: [<c028c81e>] dev_mc_sync+0x1c/0x59
> [  728.456867] 
> [  728.456869] but task is already holding lock:
> [  728.456875]  (&dev->addr_list_lock){-...}, at: [<c0287ffe>] dev_set_rx_mode+0x19/0x2b
> [  728.456894] 
> [  728.456895] other info that might help us debug this:
> [  728.456902] 2 locks held by NetworkManager/8287:
> [  728.456908]  #0:  (rtnl_mutex){--..}, at: [<c029150a>] rtnl_lock+0x14/0x16
> [  728.456929]  #1:  (&dev->addr_list_lock){-...}, at: [<c0287ffe>] dev_set_rx_mode+0x19/0x2b
> [  728.456949] 
> [  728.456951] stack backtrace:
> [  728.456961] Pid: 8287, comm: NetworkManager Not tainted 2.6.26-05781-g44ea66a #25
> [  728.456999]  [<c014568e>] __lock_acquire+0x99f/0xcc5
> [  728.457037]  [<c0144924>] ? trace_hardirqs_on+0xb/0xd
> [  728.457054]  [<c01448ce>] ? trace_hardirqs_on_caller+0xd2/0x11d
> [  728.457076]  [<c0145da6>] lock_acquire+0x6a/0x90
> [  728.457091]  [<c028c81e>] ? dev_mc_sync+0x1c/0x59
> [  728.457109]  [<c02f7189>] _spin_lock_bh+0x26/0x53
> [  728.457126]  [<c028c81e>] ? dev_mc_sync+0x1c/0x59
> [  728.457143]  [<c028c81e>] dev_mc_sync+0x1c/0x59
> [  728.457159]  [<f90bebd6>] ieee80211_set_multicast_list+0xca/0xd2 [mac80211]
> [  728.457223]  [<c0287f6c>] __dev_set_rx_mode+0x7e/0x81
> [  728.457239]  [<c0288005>] dev_set_rx_mode+0x20/0x2b
> [  728.457255]  [<c028ad54>] dev_open+0x84/0x9e
> [  728.457269]  [<c0288e9d>] dev_change_flags+0xa1/0x14f
> [  728.457286]  [<c0290af3>] do_setlink+0x250/0x300
> [  728.457308]  [<c02f7000>] ? _read_unlock+0x22/0x25
> [  728.457327]  [<c0291a8f>] rtnl_setlink+0xa9/0xc1
> [  728.457364]  [<c01448e4>] ? trace_hardirqs_on_caller+0xe8/0x11d
> [  728.457384]  [<c02919e6>] ? rtnl_setlink+0x0/0xc1
> [  728.457401]  [<c02916c7>] rtnetlink_rcv_msg+0x197/0x1b1
> [  728.457424]  [<c0291530>] ? rtnetlink_rcv_msg+0x0/0x1b1
> [  728.457441]  [<c029e55d>] netlink_rcv_skb+0x35/0x7a
> [  728.457460]  [<c0291528>] rtnetlink_rcv+0x1c/0x24
> [  728.457476]  [<c029e381>] netlink_unicast+0x1ad/0x20e
> [  728.457499]  [<c029eaca>] netlink_sendmsg+0x248/0x255
> [  728.457530]  [<c027e91d>] sock_sendmsg+0xe3/0xfe
> [  728.457562]  [<c0138a71>] ? autoremove_wake_function+0x0/0x35
> [  728.457583]  [<c010878a>] ? native_sched_clock+0xd5/0xf4
> [  728.457609]  [<c010857f>] ? sched_clock+0xb/0x1c
> [  728.457628]  [<c0142ca9>] ? lock_release_holdtime+0x3f/0x44
> [  728.457652]  [<c0208670>] ? copy_from_user+0x45/0x68
> [  728.457672]  [<c02852d6>] ? verify_iovec+0x45/0x73
> [  728.457693]  [<c027ea8a>] sys_sendmsg+0x152/0x1ad
> [  728.457713]  [<c027f541>] ? sys_recvmsg+0x177/0x184
> [  728.457734]  [<c019136e>] ? fget_light+0x95/0xb5
> [  728.457757]  [<c02088db>] ? copy_to_user+0x47/0x50
> [  728.457776]  [<c027f3b2>] ? move_addr_to_user+0x5b/0x73
> [  728.457796]  [<c027f717>] ? sys_getsockname+0x70/0x7b
> [  728.457814]  [<c02f702d>] ? _spin_unlock_bh+0x2a/0x2d
> [  728.457831]  [<c028045d>] ? release_sock+0xb3/0xbb
> [  728.457851]  [<c0281909>] ? sock_setsockopt+0x49d/0x4a8
> [  728.457874]  [<c0191384>] ? fget_light+0xab/0xb5
> [  728.457909]  [<c027fa05>] sys_socketcall+0x168/0x183
> [  728.457935]  [<c0103a0b>] sysenter_past_esp+0x78/0xc5
> [  728.457969]  =======================
