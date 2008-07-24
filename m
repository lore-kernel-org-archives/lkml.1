Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYGXXsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYGXXsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 19:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGXXr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 19:47:57 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:63412 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYGXXr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 19:47:57 -0400
Date: Thu, 24 Jul 2008 19:47:04 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [ANNOUNCE] ACPI BIOS Guideline for Linux
In-reply-to: <200807241732.23412.trenn@suse.de>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0807241937500.6098@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241732.23412.trenn@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not an ACPI specification violation that Linux
(and ACPICA) claim compatibility with the interfaces
advertised by one or multiple versions of Windows.

Yes, there are be cases where BIOS vendors will want
to know if the running version of Linux supports,
or does not support, an interface/feature.

We (the Linux community that maintain Linux/ACPI) are
eager to support them in this.  However, the interface
needs to be sufficiently defined so that we know when
to _not_ advertise that feature.

eg. There are proposals for

_OSI("Linux-Needs ATI S3 video re-POST")
_OSI("Linux-Needs NVIDIA S3 video re-POST")
_OSI("Linux-Native IPMI Support")

and we'd compile these into Linux based on the capabilities
of the build.  I'm sure that these would not be perfect --
as the BIOS would probably query these at _INI time before
the (likely loadable module) drivers that influence these
features would be loaded.  So we'd probably have to build
them into the core based on the assumption that the driver
built with the core will actually get loaded.

But this is the kind of Linux-specific OSI string we can advertise,
and choose not to advertise -- depending on the build.

thanks,
-Len
