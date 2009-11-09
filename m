Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZKIP1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZKIP1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZKIP1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:27:08 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:47568 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756034AbZKIP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:27:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAM/D90pGGN1W/2dsb2JhbACBTtwpgjuCAwQ
Date: Mon, 9 Nov 2009 10:27:11 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: LTTng 0.166 for 2.6.31.5 : refactoring/cleanup - 32-bit fix
Message-ID: <20091109152711.GA27475@Krystal>
References: <20091103061753.GA5815@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091103061753.GA5815@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:24:32 up 83 days,  2:14,  2 users,  load average: 0.88, 0.61,
	0.40
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A little word to tell about the updated LTTng 0.166, which fixes a trace
session destruction type-size problem on 32-bit machines introduced in
0.165. A simple printk() expecting a size_t rather than an unsigned long
caused this.

Mathieu


* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> I just finished testing the LTTng refactoring. It consists of:
> 
> - Change design to inheritance for channels and buffers.
>   - Eliminate structure duplication for locking/allocation level of buffer and
>     channel.
>   - Remove now unnecessary krefs.
> - Fix cpu hotplug for timers.
> - Cleanups.
> 
> Impact:
> - Cleaner code.
> - Simpler structures for channel/buffers.
> - Smaller d-cache footprint.
> 
> It also permits to change the license of all LTTng modules needed both
> for kernel and user-space tracing to dual LGPL/GPL license.
> 
> Due to the size of this change, review and testing would be very
> welcome. I decided to do it in a separate patch on top of the tree
> rather than rebasing. Considering the size of this modification, going
> over the modified code on a file by file basis rather than looking at
> the patch itself is probably easier.
> 
> I decided to mark the "locked" and "irqoff" locking schemes as "BROKEN"
> for now and focus on the lockless scheme. We could re-create them if
> needed by deriving from the lockless code-base.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
