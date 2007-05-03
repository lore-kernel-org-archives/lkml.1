Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXECLXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXECLXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbXECLXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:23:07 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2609 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbXECLXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:23:05 -0400
Date: Thu, 3 May 2007 12:22:50 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: dead CONFIG_ variables:  drivers/scsi/
Message-ID: <20070503112250.GE12018@flint.arm.linux.org.uk>
Mail-Followup-To: "Robert P. J. Day" <rpjday@mindspring.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <Pine.LNX.4.64.0705030606570.32341@localhost.localdomain> <20070503111113.GC12018@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705030713210.680@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 07:17:34AM -0400, Robert P. J. Day wrote:
> p.s.  "CONFIG_" prefix aside, i would think it's also a bit yucky to
> be checking for the definition of a preprocessor symbol that you've
> already hardcoded out of existence in the same source file.  :-)

No, because the way you turn them on (as intended) is to do:

perl -pi -e 's/undef/define/ if m/CONFIG_ACORNSCSI_CONSTANTS/' \
 drivers/scsi/arm/acornscsi.c

(or via your text editor).

An alternative way around the issue is to keep a separate patch
outside of mainline which patches the additional code and data into
the driver.  That's far less maintainable, and leads to additional
problems.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
