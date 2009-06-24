Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZF0L3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZF0L3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZF0L3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:29:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40976 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZF0L3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:29:32 -0400
Date: Wed, 24 Jun 2009 17:05:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 3/4] intel_txt: Intel(R) TXT Sx shutdown support
Message-ID: <20090624150506.GK1784@ucw.cz>
References: <4A4024C2.3050107@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4024C2.3050107@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 17:41:38, Joseph Cihula wrote:
> Support for graceful handling of sleep states (S3/S4/S5) after an Intel(R) TXT launch.
> 
> Without this patch, attempting to place the system in one of the ACPI sleep
> states (S3/S4/S5) will cause the TXT hardware to treat this as an attack and
> will cause a system reset, with memory locked.  Not only may the subsequent
> memory scrub take some time, but the platform will be unable to enter the
> requested power state.
> 
> This patch calls back into the tboot so that it may properly and securely clean
> up system state and clear the secrets-in-memory flag, after which it will place
> the system into the requested sleep state using ACPI information passed by the kernel.

I don't get this. In case of hibernation... how do you 'protect' the
data in memory?

This really needs big Documentation/ patch explaining the design
before it can be reviewed properly.

What does it protect? All kernel memory? How does it handle S3? Who
does encryption for hibernation?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
