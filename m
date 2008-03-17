Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYCQR3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYCQR3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYCQR3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:29:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:56173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYCQR3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:29:46 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: =?iso-8859-1?q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
Date: Mon, 17 Mar 2008 13:27:15 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org> <47DC66A8.1020905@tremplin-utc.net>
In-Reply-To: <47DC66A8.1020905@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803171327.16695.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with Linus' decision to revert/disable this feature.
I think it is appropriate to muck with this in -mm, but not in -rc6
Kudos to Christoph, who recommended we revert it back at -rc2.

> > What's the problem with just loading a new DSDT later? Potentially as in 
> > *much* later: including when user-space is all up-and-running? 

I don't think re-loading the DSDT at run-time would be practical.

First, booting with the OEM DSDT may nullify the benefit
of overriding the OEM DSDT -- the damage may have already been done.

Secondly, unwinding everything that depends on the DSDT is on the
order of kexec or suspend/resume.  We're talking about all the stuff
that PNP does at boot time, plus device discovery and driver binding.

The feature on the table here is an initrd DSDT override.
We already have the ability to statically compile a DSDT
override into the kernel image.  That capability is sufficient
for kernel developers.

The initrd version of the DSDT override is really for one scenario.
Somebody who has a BIOS that even Windows can't deal with -- so
no amount of "Windows bug compatbility" will help Linux with it.
They must be capable eough to generate or acquire a modified DSDT.
They must be unwilling/unable to re-build their kenrel from scratch
each time they update it.  Eg. following debian unstable updates etc.

I think that customer deserves support, particularly because they get
bragging rights that Linux works better on a box build for Windows
than Windows does:-)
However, I don't think there are enough customers like this to
justify a huge effort that would add risk to Linux.

-Len
