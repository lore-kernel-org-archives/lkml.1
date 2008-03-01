Return-Path: <linux-kernel-owner+w=401wt.eu-S1756355AbYCAFVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbYCAFVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYCAFVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:21:09 -0500
Received: from mail.suse.de ([195.135.220.2]:42735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYCAFVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:21:08 -0500
Date: Fri, 29 Feb 2008 21:12:47 -0800
From: Greg KH <gregkh@suse.de>
To: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v7] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080301051247.GB19353@suse.de>
References: <20080229002341.GA21420@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229002341.GA21420@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:23:41PM -0700, Alex Chiang wrote:
> Hi Gary, John, Kenji-san, et. al,
> 
> Well, first Gary was on holiday for a month, and then I was on
> holiday for a month, but I'm back now, and have refreshed this
> patch series against 2.6.25.
> 
> The major thing that happened was all the kobject changes
> (learned my lesson about taking long holidays when holding onto a
> largish chunk of code that hasn't been accepted yet ;), and so
> the only real change is in patch 3/4.
> 
> The kobject changes were nice, btw. In the prior versions of this
> series, I could never figure out why my kobjects weren't getting
> released when their refcounts went to 1, and had some hacky code
> in there to manually release them. (I'm sure I was doing
> something wrong, but I couldn't figure out what.) I was able to
> remove that hack in this series because the kobjects are working
> the way they're supposed to.
> 
> I did turn on kobject debugging, and all seems well except for
> one little thing. I based my module (pci_slot) on acpiphp, and
> the kobject system complains:
> 
> kobject: 'acpiphp' (a00000020476aed0): does not have a release()
> function, it is broken and must be fixed.
> 
> kobject: 'pci_slot' (a000000204791e50): does not have a release()
> function, it is broken and must be fixed.
> 
> Not quite sure what to do about these yet, but since no one has
> fixed acpiphp yet, I'm thinking that I can't be *too* wrong. :)

Um, the obvious solution of providing a release function for these
kobjects is somehow not correct?

Please do that, otherwise the code is wrong (and yes, acpiphp might be
wrong as well, I haven't seen that report yet.)

thanks,

greg k-h
