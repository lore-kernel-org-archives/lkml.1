Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbXIUIk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbXIUIk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 04:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbXIUIkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 04:40:15 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:58505 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752771AbXIUIkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 04:40:13 -0400
Date: Fri, 21 Sep 2007 10:43:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       haveblue@us.ibm.com
Subject: Re: [PATCH v2] hwmon: Update Documentation/hwmon/sysfs-interface
Message-ID: <20070921104326.36f0ee1e@hyperion.delvare>
In-Reply-To: <20070917184310.GN30825@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com>
	<20070828015029.GA10107@khazad-dum.debian.net>
	<20070828131942.18449886@hyperion.delvare>
	<20070828164905.GM32667@tree.beaverton.ibm.com>
	<20070828232504.GP32667@tree.beaverton.ibm.com>
	<20070911132335.GJ31992@jupiter.solarsys.private>
	<20070914192924.GL30825@tree.beaverton.ibm.com>
	<20070917192808.44ad60cc@hyperion.delvare>
	<20070917184310.GN30825@tree.beaverton.ibm.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

On Mon, 17 Sep 2007 11:43:11 -0700, Darrick J. Wong wrote:
> On Mon, Sep 17, 2007 at 07:28:08PM +0200, Jean Delvare wrote:
> > First of all, please think of a better subject line for this patch.
> > "Update Documentation/hwmon/sysfs-interface" is too vague when your
> > patch is rather specific.
> 
> Will change to:
> "Add power meter spec to Documentation/hwmon/sysfs-interface"

Sounds good, thanks.

> > > +power[1-*]_average_lowest	Historical average minimum power use
> > > +				Unit: microWatt
> > > +				RO
> > 
> > How useful are historical extremes of an average?
> 
> I don't know if anybody ever really requires this data, but the device
> I'm talking to records the extremes in hardware, so I put it in the driver.

OK, fine with me then.

> > > +power[1-*]_high_low_reset	Reset input_highest/input_lowest.
> > > +				WO
> > 
> > I don't much like this name. It sounds like a name crafted for the
> > specific feature of a given chip, while we try to use generic names for
> 
> Guilty as charged.  Since ibmpex is the only on-board power meter hardware
> to which I have access, the interface proposal includes the various odd
> pieces that the hardware provides in addition to the meters.  I
> could take the historical extreme and reset bits out of the proposal and
> put them in something like Documentation/hwmon/ibmpex.txt as extra
> chip-specific features if people prefer that.

I'm fine having them in the spec as long as the interface is made
generic enough.

> > the standard interface. I would rather go for power[1-*]_reset_history
> 
> Me too.
> 
> > if we have a single file for resetting all the extremes of a given
> > channel, or power[1-*]_input_lowest_reset and
> > power[1-*]_input_highest_reset if we go for a per-value reset.
> 
> The ibmpex hardware only knows how to reset all of them.

This doesn't mean we do not want separate files. The same problem
exists for many other hardware monitoring features. For example most
thermal sensor chips have one high temperature limit per temperature
channel. However some of them have a single limit register for several
channels! The approach we have taken so far was to have individual
files, and it's up to the driver to keep them in sync.

Another example is alarm files. Some chips have a single alarm for
out-of-range voltage measurements. Others have separate alarms for low
voltage and high voltage limit crossing. In that case, we decided to
have either a single file (in0_alarm) or separate files (in0_min_alarm
and in0_max_alarm) depending on what the chip supports. Admittedly this
is not very consistent with what we did for the shared temperature
limits.

> > Alternatively, we could simply make the power[1-*]_input_lowest and
> > power[1-*]_input_highest files writable, and "cat power1_input >
> > power1_input_lowest" (or any write?) would reset the history.
> 
> I'd prefer to leave it explicitly called out as a separate sysfs knob,
> unless there are established precedents for resetting a sensor by
> writing something to its sysfs file.

No, there's no such established precedent. This was only a suggestion
from me as it seems to make some sense. If you don't like the idea,
just ignore it.

-- 
Jean Delvare
