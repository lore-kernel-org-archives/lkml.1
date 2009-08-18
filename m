Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZHRXcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZHRXcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZHRXcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:32:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50515 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZHRXcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:32:51 -0400
Date: Tue, 18 Aug 2009 16:32:47 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH 1/2] hwmon: Enhance the sysfs API for power meters.
Message-ID: <20090818233247.GC10233@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20090725004322.20709.96804.stgit@elm3a70.beaverton.ibm.com> <20090725004328.20709.57712.stgit@elm3a70.beaverton.ibm.com> <20090807180906.GD1728@ucw.cz> <20090808174020.GA29600@tux1.beaverton.ibm.com> <20090808214830.GC24153@elf.ucw.cz> <20090810211211.GB30815@tux1.beaverton.ibm.com> <20090812115653.GJ24339@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812115653.GJ24339@elf.ucw.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:56:54PM +0200, Pavel Machek wrote:

> Is netlink right interface for that? Perhaps /sys files should be
> pollable?

Since the ACPI meter receives ACPI events, it seems logical to me that these
events should be passed through to ACPI clients.  It also seems logical that
hwmon clients shouldn't have to know about ACPI netlink sockets either, so
I'll combine them both and see what popular consensus thinks of that. :)

Therefore, I updated the patch to make the appropriate sysfs files pollable,
and the hwmon sysfs documentation to state that they can be polled.

> > So it goes with ACPI.  Given that things like Node Manager and Active Energy
> > Manager claim to be able to control power use, I would guess that it is
> > generally likely that a power monitoring system would take action on its own to
> > cut power use, and not necessarily bothering to tell the OS exactly what it's
> > doing.
> 
> I guess this needs to be clarified/documented properly because it
> should go anywhere near mainline.

Ok, I'll clarify the documentation to say that those two scenarios are
possible, and to contact the machine vendor for details.

--D
