Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbXKTBMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbXKTBMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbXKTBMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:12:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbXKTBMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:12:40 -0500
Date: Mon, 19 Nov 2007 20:12:36 -0500
From: Dave Jones <davej@redhat.com>
To: Stephen Clark <Stephen.Clark@seclark.us>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Power Saving
Message-ID: <20071120011236.GA17420@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Clark <Stephen.Clark@seclark.us>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <47422D3B.8080704@seclark.us> <20071120005443.GB9243@redhat.com> <474232D9.20407@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474232D9.20407@seclark.us>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 08:05:29PM -0500, Stephen Clark wrote:
 
 > >I think by throttling, you actually mean changing frequency/voltage ?
 > >(throttling is something else, where the CPU skips every n cycles,
 > > which doesn't actually save any power)
 > >
 > well what about the info from /proc/
 > 
 > cat /proc/acpi/processor/CPU0/info
 > processor id:            0
 > acpi id:                 0
 > bus mastering control:   no
 > power management:        yes
 > throttling control:      yes
 > limit interface:         yes
 > 
 > and:
 > cat /proc/acpi/processor/CPU0/throttling
 > state count:             2
 > active state:            T0
 > states:
 >    *T0:                  00%
 >     T1:                  50%

See above. These are throttling states, used typically
if the system is overheating.

 > [root@joker ~]# cat /proc/acpi/processor/CPU0/power
 > active state:            C2
 > max_cstate:              C8
 > bus master activity:     d18324c9
 > states:
 >     C1:                  type[C1] promotion[C2] demotion[--] 
 > latency[000] usage[01340140]
 >    *C2:                  type[C2] promotion[--] demotion[C1] 
 > latency[090] usage[02980043]
 > 
 > ????

C states are unrelated to frequency/voltage scaling (which are P states)
They get taken advantage of automatically by ACPI as you can
see from the usage fields.

	Dave

-- 
http://www.codemonkey.org.uk
