Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbYGITfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbYGITfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYGITfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:35:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47818 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYGITfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:35:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [linux-pm] [RFC PATCH 0/4] save and restore ACPI NVS memory during hibernation
Date: Wed, 9 Jul 2008 21:37:18 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Zhang Rui <rui.zhang@intel.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1215051868.5628.32.camel@rzhang-dt.sh.intel.com> <20080708193752.GD8694@ucw.cz>
In-Reply-To: <20080708193752.GD8694@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092137.18966.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of July 2008, Pavel Machek wrote:
> Hi!
> 
> > According to the ACPI spec, ACPI NVS memory region is required to
> > be saved/restored by OS during hibernation.
> > 
> > Section 15.3.2 ACPI Spec 3.0b,
> > "OSPM will call the _PTS control method some time before entering
> > a sleeping state, to allow the platform???s AML code to update
> > this memory image before entering the sleeping state.
> > After the system awakes from an S4 state, OSPM will restore this
> > memory area and call the _WAK control method to enable the BIOS
> > to reclaim its memory image."
> > 
> > This patch set add the mechanism to save/restore ACPI NVS memory
> > during hibernation.
> > 
> > Patch 01: call platform_begin before swsusp_shrink_memory.
> > 	So that we can allocate enough pages for ACPI NVS memory
> > 	before shrink the memory.
> 
> Why is it neccessary to allocate memory for a copy? We should be able
> to save ACPI NVS area same way we are saving kernel pages, no?

Because we want to restore it from the hibernated kernel (when it gets control
back again).

Thanks,
Rafael
