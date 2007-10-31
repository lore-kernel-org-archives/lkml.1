Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXJaBan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXJaBan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXJaBac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:30:32 -0400
Received: from outbound-mail-56.bluehost.com ([69.89.20.36]:54973 "HELO
	outbound-mail-56.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753245AbXJaBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:30:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Date: Tue, 30 Oct 2007 18:30:13 -0700
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <4727C126.8070000@shaw.ca> <alpine.LFD.0.999.0710301653330.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710301653330.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710301830.14429.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2007 4:59 pm Linus Torvalds wrote:
> Also, there are several devices that don't show up in the MMCFG
> things, or just otherwise get it wrong.
>
> So just take a look at arch/x86/pci/mmconfig-shared.c and look for
> "conf1".
>
> Really. Damn, I'm nervous taking any MMCFG patches that has you as an
> author, if you aren't even aware of these kinds of fundamnetal
> issues. You probably read the standards about how things are
> "supposed" to work, and then just believed them?

We have a few bits of code in there to look at the actual MMCONFIG base 
register, which is good since we can sanity check it against the 
firmware.  However, by itself it's not enough since we may end up using 
it even though the BIOS didn't tell us about an overlap that really 
does exist.  Robert recognized this and added checks to make sure the 
values read from the base regs actually matched what the firmware was 
telling us in the ACPI tables (at least iirc, it's been awhile since I 
looked at the patch).

So don't be too nervous. :)

Jesse
