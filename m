Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZJ0RaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZJ0RaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZJ0RaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:30:16 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45573 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbZJ0RaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:30:15 -0400
Date: Tue, 27 Oct 2009 10:30:01 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Crane Cai <crane.cai@amd.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] acpi: support IBM SMBus CMI devices
Message-ID: <20091027173001.GT26149@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091021023016.GC32413@crane-desktop> <200910210857.13978.bjorn.helgaas@hp.com> <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091022071748.GA17917@crane-desktop> <20091022174304.GO26149@tux1.beaverton.ibm.com> <20091023044451.GB1367@crane-desktop> <20091023170311.GC21723@tux1.beaverton.ibm.com> <20091025125353.55d3bfad@hyperion.delvare> <20091026205819.GR26149@tux1.beaverton.ibm.com> <20091027180332.62f2c758@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027180332.62f2c758@hyperion.delvare>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 06:03:32PM +0100, Jean Delvare wrote:

> I'm only half please with this. You change the function named, but it
> doesn't follow the calling convention of acpi_dock_match(), which is a
> little confusing.
> 
> Anyway, I will need an ack from the ACPI people before I can pick this
> patch. Or maybe they should even push it upstream themselves.

I am confused.  Looking at that bunch of ifs, acpi_is_video_device returns 1
for a match and 0 for no match.  acpi_bay_match returns 0 for a match and
-ENODEV for no match, which just happens to work with the ACPI_SUCCESS macro.
acpi_dock_match returns ACPI error codes.  Each of the three existing tests has
different return value semantics, so it is not clear to me which one I should
use.

I didn't think it was correct for my probe function to use the ACPI_STATUS
macro unless it returned ACPI error codes... which it does not.  -ENODEV seemed
appropriate for "no device found".

Is it desirable to clean them all up to follow the same convention?

--D
