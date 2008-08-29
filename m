Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYH2Khd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYH2Khd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYH2KhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:37:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51552 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYH2KhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:37:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Fri, 29 Aug 2008 12:41:03 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
References: <200808290002.55026.rjw@sisk.pl> <48B7C979.1000606@gmail.com>
In-Reply-To: <48B7C979.1000606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291241.04183.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of August 2008, Tejun Heo wrote:
> Hello,
> 
> Rafael J. Wysocki wrote:
> > It appears that the "double spin-off" problem described in
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8855
> > 
> > has recently started to appear during hibernation as well as during shutdown.
> > It didn't appear during hibernation on my hp nx6325 with 2.6.26, so this is a
> > recent regression.
> > 
> > I have prepared the appended patch that fixes the problem for me, based on the
> >  earlier Tejun's patch at
> > 
> > http://bugzilla.kernel.org/attachment.cgi?id=15441&action=view
> > 
> > but I'm not really sure if this is an acceptable solution.  Please advise.
> > 
> > Thanks,
> > Rafael
> > 
> > 
> > not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The libata part looks fine to me but what are those SYSTEM_SUSPEND_DISK
> stuff?  They don't look like belonging to this patch.

Actaully, they do belong to it.  This is the part "fixing" the hibernation code
path, in which the disk is also powered off unnecessarily.

Well, probably I should use SYSTEM_HIBERNATE_ENTER or something similar
instead of SYSTEM_SUSPEND_DISK.

In short, the idea is to change system_state to something specific to the last
phase of hibernation (after saving the image) and check that in
ata_scsi_start_stop_xlat().  In fact that's completely analogous to what's done
for SYSTEM_POWER_OFF in there.

Thanks,
Rafael
