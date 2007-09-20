Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbXITPK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbXITPK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXITPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:10:19 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:42789 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755228AbXITPKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:10:17 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2007 11:10:17 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: MTRR initialization
Date: Thu, 20 Sep 2007 08:03:31 -0700
User-Agent: KMail/1.9.7
Cc: Jesse Barnes <jesse.barnes@intel.com>, Howard Chu <hyc@symas.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46EAB7DA.10507@symas.com> <200709191452.57505.jesse.barnes@intel.com> <p73d4wdal00.fsf@bingen.suse.de>
In-Reply-To: <p73d4wdal00.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709200803.31795.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 19, 2007 11:50:23 pm Andi Kleen wrote:
> Jesse Barnes <jesse.barnes@intel.com> writes:
> > To do this in a nicer way (and be less vulnerable to similar BIOS
> > funkiness) the kernel really needs full PAT support.  That should allow
> > WC over WB and WC over UC mappings to occur, at least if I'm
> > remembering the docs right...
>
> PAT only really helps for device driver performance optimizations.
> But if the basic WB MTRRs are wrong PAT cannot really salvage it.

Look at the original bug report.  There's a bug WB region so any subsequent WC 
mappings via the MTRRs won't work, so you need PAT to do WC (unless you want 
to rewrite all your MTRR settings as Howard has to do now).

Seems like more and more machines are being setup this way, and until we have 
PAT users will have to jump through hoops to get good performance.

Jesse
