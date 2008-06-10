Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYFJUsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYFJUsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYFJUs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:48:28 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60235 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYFJUs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:48:27 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	<yq1iqwhia2m.fsf@sermon.lab.mkp.net>
	<x49mylt9lbn.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 10 Jun 2008 16:47:52 -0400
In-Reply-To: <x49mylt9lbn.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's message of "Tue\, 10 Jun 2008 14\:49\:48 -0400")
Message-ID: <yq1abhtnhjb.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

Jeff> So, is it safe to say that the library routines for
Jeff> integrity-aware file systems have not been tested at all?
Jeff> Specifically, I'm talking about: bio_integrity_tag_size
Jeff> bio_integrity_set_tag bio_integrity_get_tag

I have not tried using them from within a filesystem, if that's what
you mean.  But I have attached random strings to bios and read them
back later.


Jeff> gcc (GCC) 4.1.2 20071124 (Red Hat 4.1.2-41)

Ok, I'm trying to chase down a 5.2 box to figure out what the problem
is.  Maybe I'll just move that function to the header file.


Jeff> I did a new clone (just to be sure I got your change) and I get
Jeff> the same problem.  I also can't see the changeset in the log, so
Jeff> are you sure you pushed it?

Yup, it's there.


Jeff> I got rid of the inline in the definition in bio.h.  The .c file
Jeff> didn't define the function as inline, so I didn't have to change
Jeff> it.  It seems to be building now.

The problem is that your gcc is unhappy about the fact that the
inlined function is defined elsewhere.  The gcc info page said only
declare it inline in the header and not the declaration.  The change I
pushed removed inline from the .c file.  But that didn't help.

-- 
Martin K. Petersen	Oracle Linux Engineering

