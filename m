Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbYKNPTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbYKNPTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYKNPSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:18:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:55408 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYKNPSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:18:54 -0500
Date: Fri, 14 Nov 2008 15:18:49 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Nick Warne <nick@ukfsn.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i8046:  unbind/bind issue with laptop system password set
Message-ID: <20081114151849.GA27298@srcf.ucam.org>
References: <20081114123058.4e7db857@palantir.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114123058.4e7db857@palantir.linicks.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:30:58PM +0000, Nick Warne wrote:
> Now, investigating further, I have found that I can replicate this whole issue with this script:
> 
> #!/bin/sh
> echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind
> sleep 5;
> echo -n "i8042" > /sys/bus/platform/drivers/i8042/bind
> 
> if I hit a key during the sleep stage, the keyboard et al all goes AWOL again.
> 
> So, I am presuming here that when my laptop gets woken up, the BIOS system password screen comes, and the /etc/acpi/resume.d/ scripts are being held in stasis until I enter the password.  BUT, I have then used the keyboard before i8042 is echoed to 'bind', and this causes the issue.  Without the system password set, the scipts perhaps run fast enough before I can hit the keyboard in this keyboard state.

Why are you binding/unbinding the keyboard? That destroys the kernel 
state about the mode the keyboard is in, and when the BIOS programs your 
keyboard into RAW mode for the BIOS password the kernel will assume that 
it should be treating it in raw mode on replug.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
