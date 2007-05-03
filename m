Return-Path: <linux-kernel-owner+w=401wt.eu-S1030926AbXECG1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030926AbXECG1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 02:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030933AbXECG1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 02:27:05 -0400
Received: from netblock-66-245-252-131.dslextreme.com ([66.245.252.131]:56389
	"EHLO Angel.zoy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030926AbXECG1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 02:27:04 -0400
Date: Wed, 2 May 2007 23:27:02 -0700
From: Michel Lespinasse <walken@zoy.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>, Jeb Cramer <cramerj@intel.com>,
       John Ronciak <john.ronciak@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: e1000 issue on DQ965GF board (was 24 lost ticks with 2.6.20.10 kernel)
Message-ID: <20070503062701.GA22255@zoy.org>
References: <20070501130715.GB29131@zoy.org> <46375E04.5030506@redhat.com> <20070501214912.GA4048@zoy.org> <4637BA70.8000108@intel.com> <20070502084146.GA6089@zoy.org> <4638D51C.7010603@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4638D51C.7010603@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:14:52AM -0700, Kok, Auke wrote:
> I just checked and the fix I was referring to earlier didn't make it into 
> 2.6.21-final. You can get 2.6.21-git1 from kernel.org which has the fix. See
> 
> http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git1.log

Good. So I tried that patch (well, actually only the change visible at
http://lkml.org/lkml/2007/3/6/268). I patched it into a 2.6.20.11 kernel,
using the same config file as previously. The good news is that this fixes
my issue: there are no lost ticks anymore, and the link does negotiate a
gigabit connection. This is a great improvement for me :)

I still seem to hit an issue if using the ethtool command, though.
when using 'ethtool -s eth0 autoneg on', the link comes up at gigabit speed,
but a couple seconds later is comes down again, and then up at 100 megabits:

e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex
e1000: eth0: e1000_watchdog: NIC Link is Down
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO

The same thing happens if I use ifdown eth0; ifup eth0 too. Once again,
I only observe this on my DQ965GF motherboard, the DG965RY board is fine
(stays at gigabit speed when I issue these commands).

Is this something you could easily reproduce at Intel or would you want me
to look into that issue on my system ?

Thanks,

-- 
Michel "Walken" Lespinasse
"Bill Gates is a monocle and a Persian cat away from being the villain
in a James Bond movie." -- Dennis Miller
