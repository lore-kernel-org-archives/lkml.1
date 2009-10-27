Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZJ0RgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZJ0RgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbZJ0RgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:36:18 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55862 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270AbZJ0RgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:36:17 -0400
Date: Tue, 27 Oct 2009 18:36:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: djwong@us.ibm.com
Cc: Crane Cai <crane.cai@amd.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] acpi: support IBM SMBus CMI devices
Message-ID: <20091027183619.16b0b952@hyperion.delvare>
In-Reply-To: <20091027173001.GT26149@tux1.beaverton.ibm.com>
References: <20091021023016.GC32413@crane-desktop>
	<200910210857.13978.bjorn.helgaas@hp.com>
	<20091021173733.GN26149@tux1.beaverton.ibm.com>
	<20091022071748.GA17917@crane-desktop>
	<20091022174304.GO26149@tux1.beaverton.ibm.com>
	<20091023044451.GB1367@crane-desktop>
	<20091023170311.GC21723@tux1.beaverton.ibm.com>
	<20091025125353.55d3bfad@hyperion.delvare>
	<20091026205819.GR26149@tux1.beaverton.ibm.com>
	<20091027180332.62f2c758@hyperion.delvare>
	<20091027173001.GT26149@tux1.beaverton.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 10:30:01 -0700, Darrick J. Wong wrote:
> On Tue, Oct 27, 2009 at 06:03:32PM +0100, Jean Delvare wrote:
> 
> > I'm only half please with this. You change the function named, but it
> > doesn't follow the calling convention of acpi_dock_match(), which is a
> > little confusing.
> > 
> > Anyway, I will need an ack from the ACPI people before I can pick this
> > patch. Or maybe they should even push it upstream themselves.
> 
> I am confused.  Looking at that bunch of ifs, acpi_is_video_device returns 1
> for a match and 0 for no match.  acpi_bay_match returns 0 for a match and
> -ENODEV for no match, which just happens to work with the ACPI_SUCCESS macro.
> acpi_dock_match returns ACPI error codes.  Each of the three existing tests has
> different return value semantics, so it is not clear to me which one I should
> use.

Ah, sorry, I looked at one (don't remember which one) and assumed the
other ones followed the same convention.

> I didn't think it was correct for my probe function to use the ACPI_STATUS
> macro unless it returned ACPI error codes... which it does not.  -ENODEV seemed
> appropriate for "no device found".
> 
> Is it desirable to clean them all up to follow the same convention?

Ideally, yes, but that would be a separate task from what you're up to
at the moment. And anyway this is not in my realm an I am not going to
work on it myself, so my opinion probably doesn't matter that much.
Sorry for bothering you with this in the first place.

-- 
Jean Delvare
