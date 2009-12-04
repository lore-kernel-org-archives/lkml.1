Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZLDIoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZLDIoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbZLDIoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:44:03 -0500
Received: from poutre.nerim.net ([62.4.16.124]:62543 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZLDIoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:44:02 -0500
Date: Fri, 4 Dec 2009 09:44:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: djwong@us.ibm.com, Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] therm_adt746x: Record pwm invert bit at 
 module load time
Message-ID: <20091204094405.4bad9d69@hyperion.delvare>
In-Reply-To: <1259893211.2076.1243.camel@pasglop>
References: <20091130234727.GA10295@tux1.beaverton.ibm.com>
	<1259893211.2076.1243.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Dec 2009 13:20:11 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2009-11-30 at 15:47 -0800, Darrick J. Wong wrote:
> > In commit 0512a9a8e277a9de2820211eef964473b714ae65, we unilaterally zero the
> > "pwm invert" bit in the fan behavior configuration register.  On my PowerBook
> > G4, this results in the fans going to full speed at low temperature and
> > shutting off at high temperature because the pwm invert bit is supposed to be
> > set.
> > 
> > Therefore, record the pwm invert bit at driver load time, and write the bit
> > into the fan behavior control register.  This restores correct behavior on my
> > PBG4 and should work around the bit being set to the wrong value after
> > suspend/resume (which is what the original patch was trying to fix).  It also
> > fixes a minor omission where the pwm invert bit correction is NOT performed
> > when switching into automatic mode.
> 
> Thanks, I'll apply.

This is a pretty serious bug, please make sure to send the fix to the
stable team for kernels 2.6.31 and 2.6.32.

-- 
Jean Delvare
