Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZEMJv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZEMJv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 05:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZEMJvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 05:51:19 -0400
Received: from av-gw1.cc.tut.fi ([130.230.130.110]:57184 "EHLO
	av-gw1.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbZEMJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 05:51:18 -0400
X-AuditID: 82e6826e-a44c3bb0000009be-7c-4a0a91972bce 
Date: Wed, 13 May 2009 12:23:35 +0300
From: Petri Kaukasoina <kaukasoina704m93hd7@sci.fi>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Clark Williams <williams@redhat.com>, zippel@linux-m68k.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tsc_khz= boot option to avoid TSC calibration variance
Message-ID: <20090513092335.GA22832@elektroni.phys.tut.fi>
Mail-Followup-To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Clark Williams <williams@redhat.com>, zippel@linux-m68k.org,
	Ingo Molnar <mingo@elte.hu>
References: <alpine.LFD.2.00.0905130027530.3561@localhost.localdomain> <4A0A9A23.24720.54D53C4@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A9A23.24720.54D53C4@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
User-Agent: Mutt/1.4.2.3i
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 09:59:59AM +0200, Ulrich Windl wrote:
> On 13 May 2009 at 0:42, Thomas Gleixner wrote:
> 
> > Honestly all this is just the futile attempt to fix the flaws of NTP
> > via (super)user interaction.
> 
> This has nothing to do with flaws in NTP (AFAIK).

Correct. When ntp is NOT RUNNING at all, if the TSC calibration gives a MHz
value differing e.g. 100 ppm from the previous value, the clock will run at
a different speed, 100 ppm making a difference of 17 seconds a day. On the
other hand, if ntp is running, it will eventually compensate the offset. But
it takes quite a long time to settle, IMO too long for a quality time
server.

The real changes in the clock frequency between bootups are in the order of
1 ppm, but the TSC calibration can be even 100 ppm off randomly.

-Petri
