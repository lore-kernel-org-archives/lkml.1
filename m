Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXHFSLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXHFSLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbXHFSLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:11:30 -0400
Received: from outbound-mail-73.bluehost.com ([69.89.20.8]:57465 "HELO
	outbound-mail-73.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753827AbXHFSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:11:28 -0400
X-Greylist: delayed 1639 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 14:11:28 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH -mm] 2/2: PCI: disable decode of IO/memory during BAR sizing
Date: Mon, 6 Aug 2007 10:11:41 -0700
User-Agent: KMail/1.9.7
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <465CF804.9070907@shaw.ca>
In-Reply-To: <465CF804.9070907@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061011.42363.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 29, 2007 9:05 pm Robert Hancock wrote:
> Change PCI BAR sizing to disable the decode of memory or IO, as
> appropriate, while we are writing the all-ones value to the BAR to
> determine the size. If this is not done, the device may spuriously
> decode accesses to memory areas it should not. On some Intel PCI
> Express chipsets, this breaks MMCONFIG configuration space access,
> since the memory the graphics card ends up decoding during this
> period overlaps the MMCONFIG area, and thus it steals the accesses to
> the area to do any other configuration space access, including
> changing the BAR back to its previous value.
>
> However, don't do this disabling on host bridge devices, as it is
> reported that some of them do silly things like disable CPU to RAM
> access if this is done.
>
> Based on an original patch by Jesse Barnes.
>
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Robert, the PCI patches for fixing up MCFG detection/usage and probing 
should go through Greg.  Can you resend so we don't miss 2.6.24 this 
time?  (I was really hoping this stuff would get into 2.6.23, but 
apparently none of the right people were Cc'd at the right time... 
damn.)

You can add my sign-off to this one too.

Thanks,
Jesse
