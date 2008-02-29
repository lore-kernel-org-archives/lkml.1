Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYB2AX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYB2AX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbYB2AXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:23:44 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34393 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbYB2AXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:23:43 -0500
Date: Thu, 28 Feb 2008 17:23:41 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net
Cc: Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
       kristen.c.accardi@intel.com, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-acpi@vger.kernel.org
Subject: [PATCH 0/4, v7] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080229002341.GA21420@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
	warthog19@eaglescrag.net, Matthew Wilcox <matthew@wil.cx>,
	gregkh@suse.de, kristen.c.accardi@intel.com, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary, John, Kenji-san, et. al,

Well, first Gary was on holiday for a month, and then I was on
holiday for a month, but I'm back now, and have refreshed this
patch series against 2.6.25.

The major thing that happened was all the kobject changes
(learned my lesson about taking long holidays when holding onto a
largish chunk of code that hasn't been accepted yet ;), and so
the only real change is in patch 3/4.

The kobject changes were nice, btw. In the prior versions of this
series, I could never figure out why my kobjects weren't getting
released when their refcounts went to 1, and had some hacky code
in there to manually release them. (I'm sure I was doing
something wrong, but I couldn't figure out what.) I was able to
remove that hack in this series because the kobjects are working
the way they're supposed to.

I did turn on kobject debugging, and all seems well except for
one little thing. I based my module (pci_slot) on acpiphp, and
the kobject system complains:

kobject: 'acpiphp' (a00000020476aed0): does not have a release()
function, it is broken and must be fixed.

kobject: 'pci_slot' (a000000204791e50): does not have a release()
function, it is broken and must be fixed.

Not quite sure what to do about these yet, but since no one has
fixed acpiphp yet, I'm thinking that I can't be *too* wrong. :)

I'm *hoping* that my misunderstanding of kobjects last time
around is what caused the weirdness on Gary's machine, and that
we won't see any more problems.

I've tested this series on my hp rx6600 with both acpiphp and
pciehp drivers, and as before, any and all combinations of those
modules can be modprobe'd/rmmod'ed in any order, etc.

I'd love to see some more testing of this, and then (hopefully!)
upstream acceptance.

Thanks!

/ac

