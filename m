Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYCOUUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYCOUUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 16:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCOUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 16:20:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbYCOUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 16:20:25 -0400
Date: Sat, 15 Mar 2008 13:19:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: ?ric Piel <Eric.Piel@tremplin-utc.net>
cc: Tilman Schmidt <tilman@imap.cc>, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       Markus Gaugusch <dsdt@gaugusch.at>, linux-acpi@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [2.6.25-rc5-mm1] BUG: spinlock bad magic early during boot
In-Reply-To: <47DC26BC.7060502@tremplin-utc.net>
Message-ID: <alpine.LFD.1.00.0803151315250.3020@woody.linux-foundation.org>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>  <47D86D43.2060108@imap.cc> <1205441216.4971.65.camel@nimitz.home.sr71.net>  <47D9C853.3040701@imap.cc> <1205517802.12763.18.camel@nimitz.home.sr71.net>  <1205525184.12763.32.camel@nimitz.home.sr71.net>
  <47DAE55C.3080506@tremplin-utc.net>  <1205530551.8167.20.camel@nimitz.home.sr71.net>  <47DB013D.3060102@tremplin-utc.net> <1205537395.8167.31.camel@nimitz.home.sr71.net> <47DBC578.7050101@imap.cc> <alpine.LFD.1.00.0803151212180.3020@woody.linux-foundation.org>
 <47DC26BC.7060502@tremplin-utc.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Mar 2008, ?ric Piel wrote:
>
> It's a pity, I had just nearly finished a new approach. Instead of
> relying on populate_rootfs() and the filesystem infrastructure, the new
> approach directly finds the file in the initramfs.

So that avoids the VFS layer issues, but it's still strictly much worse 
than just having a run-time loading.

What's the problem with just loading a new DSDT later? Potentially as in 
*much* later: including when user-space is all up-and-running? 

For things like DVD install images, you'd quite possibly want to have a 
few known-workaround DSDT images with the installer, and just say "ok, we 
want to fix up this ACPI crap in order to get working suspend/resume" kind 
of thing.

So what's the reason for pushing for this insanely-early workaround in the 
first place, instead of letting user-space do something like

	cat my-dsdt-image > /proc/sys/acpi/DSDT

or whatever at runtime?

		Linus
