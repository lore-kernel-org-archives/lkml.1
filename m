Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZLBL4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZLBL4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZLBL4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:56:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZLBL4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:56:17 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Christoph Hellwig <hch@lst.de>
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Date: Wed, 2 Dec 2009 12:56:20 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125102857.GA28310@lst.de> <20091126022311.GB22613@khazad-dum.debian.net> <20091126095202.GA15932@lst.de>
In-Reply-To: <20091126095202.GA15932@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912021256.21683.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 10:52:02 Christoph Hellwig wrote:
> On Thu, Nov 26, 2009 at 12:23:11AM -0200, Henrique de Moraes Holschuh wrote:
> > If you go back to the previous kernel, does the problem disappear?  Please
> > test and report (don't go by past experiences).
> 
> Yes - in fact I had to revert to 2.6.31 because 2.6.32-rc is totally
> unusable for a kernel developers workload (this issue plus the wifi
> disconnects reported elsewhere).
> 
> > If it does disappear, what are the highest temperatures your thinkpad hits?
> 
> I haven't found a good monitoring applet to do constant monitoring, but
> the highest I've seen was around 95C so far.
The critical temperature for the shutdown should still be logged in:
/var/log/messages
Can you grab that one out, please.

But from what we know, this sounds like a real overheating and not a
wrongly read value, also thinkpads used to have a switch to let the
temperature jump above the critical trip point under certain conditions.
This seem to be the case on THM0 (I remember 127 C...):
/proc/acpi/thermal_zone/THM0/trip_points:critical (S5):           127 C

Can we be sure it's because of the fans?
2.6.31 works?
Also the latest stable one?
Then this one might be unrelated (11.2, 2.6.31.X based, Acer Aspire 5315):
[Bug 557850] System Fan is being stopped on boot, CPU goes overheated and shut down instantly
https://bugzilla.novell.com/show_bug.cgi?id=557850

       Thomas
