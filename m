Return-Path: <linux-kernel-owner+w=401wt.eu-S1758211AbYFWOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211AbYFWOba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYFWObV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:31:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43579 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYFWObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:31:20 -0400
Date: Mon, 23 Jun 2008 15:31:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: LMSENSORS: 2.6.26-rc,  enabling ACPI Termal Zone support costs sensors
Message-ID: <20080623143112.GA4160@srcf.ucam.org>
References: <485DA11C.7050906@keyaccess.nl> <485DFF35.6080008@hhs.nl> <485E505F.8010306@keyaccess.nl> <485E61DE.6020202@hhs.nl> <20080623120844.5f722aa6@hyperion.delvare> <485F79C6.20507@keyaccess.nl> <20080623135704.2980078c@hyperion.delvare> <485F9877.1060902@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485F9877.1060902@keyaccess.nl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 02:35:03PM +0200, Rene Herman wrote:
> libsensors dictated the ABI rule that the hwmon directories must have 
> device backlinks; the new ACPI Thermal Zone hwmon interface breaks that 
> bit of ABI. It is not relevant that that ABI may have gotten to be as a 
> result of unfortunate programming on the userspace side -- the only 
> thing relevant is that it IS. lm-sensors 2 is on millions of systems out 
> there. This is not meant agressively, or whatever you guys seem to want 
> to read in my words, it's un undeniable fact.

No, libsensors made an assumption about the ABI that turns out not to be 
true. The ABI hasn't changed, libsensors is just being exposed to a case 
it didn't previously see.

We've had this kind of change before. The ACPI backlight code changed in 
such a way that scripts that blindly wrote values instead of (correctly) 
reading the maximum brightness value broke. mmap's behaviour changed in 
such a way that it was no longer possible for vm86 to execute code that 
wasn't mapped as executable, breaking libx86. The applications in 
question were undeniably buggy. Those are examples that I was personally 
involved with - I'm sure there are others. Where userspace has made 
false assumptions, it's not the kernel's responsibility to continue to 
support those assumptions.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
