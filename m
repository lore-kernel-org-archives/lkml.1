Return-Path: <linux-kernel-owner+w=401wt.eu-S933747AbZIDQai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747AbZIDQai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932747AbZIDQaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:30:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46079 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZIDQae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:30:34 -0400
Date: Fri, 4 Sep 2009 17:30:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 2/2] rtc: Add boot_timesource sysfs
	attribute
Message-ID: <20090904163029.GA25239@srcf.ucam.org>
References: <1252081568-6000-1-git-send-email-mjg@redhat.com> <1252081568-6000-2-git-send-email-mjg@redhat.com> <20090904182528.591dbd29@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904182528.591dbd29@i1501.lan.towertech.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 06:25:28PM +0200, Alessandro Zummo wrote:

>  This feature is meant to be in addition of the regular
>  hwclock call to read the system time.
> 
>  Have you tested if there are drawbacks by not reading it? Like
>  TZ, DST and similar?

Current util-linux has a hwclock that can just set the timezone without 
performing a full read. However, there's no way of knowing whether it's 
safe to do this without knowing that the kernel config option was set 
and used. We'd prefer to avoid always doing --hctosys because it's a 
noticable performance hit on boot if the work's already been done by the 
kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
