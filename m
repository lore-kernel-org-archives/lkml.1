Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZF0L31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZF0L31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZF0L3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:29:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40952 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZF0L3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:29:18 -0400
Date: Wed, 24 Jun 2009 17:04:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 2/4] intel_txt: Intel(R) TXT reboot/halt
	shutdown support
Message-ID: <20090624150453.GJ1784@ucw.cz>
References: <4A4024BE.5090206@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4024BE.5090206@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 17:41:34, Joseph Cihula wrote:
> Support for graceful handling of kernel reboots after an Intel(R) TXT launch.
> 
> Without this patch, attempting to reboot or halt the system will cause the
> TXT hardware to lock memory upon system restart because the secrets-in-memory
> flag that was set on launch was never cleared.  This will in turn cause BIOS
> to execute a TXT Authenticated Code Module (ACM) that will scrub all of memory
> and then unlock it.  Depending on the amount of memory in the system and its type,
> this may take some time.
> 
> This patch creates a 1:1 address mapping to the tboot module and then calls back
> into tboot so that it may properly and securely clean up system state and clear
> the secrets-in-memory flag.  When it has completed these steps, the tboot module
> will reboot or halt the system.

Is it faster to clean memory from OS as opposed to bios doing the
clearing? If so, why?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
