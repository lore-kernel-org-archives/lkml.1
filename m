Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbYBAH2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbYBAH2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYBAH2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:28:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40412 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYBAH2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:28:13 -0500
Date: Fri, 1 Feb 2008 08:28:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Frank Seidel <fseidel@suse.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nozomi: constify driver
Message-ID: <20080201072815.GA5345@uranus.ravnborg.org>
References: <200801312210.30722.fseidel@suse.de> <Pine.LNX.4.64.0801312238170.4864@fbirervta.pbzchgretzou.qr> <200802010725.05421.fseidel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802010725.05421.fseidel@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 07:25:05AM +0100, Frank Seidel wrote:
> On Thursday 31 January 2008 22:39, Jan Engelhardt wrote:
> > On Jan 31 2008 22:10, Frank Seidel wrote:
> > >(Re: [PATCH 012/196 ver2] nozomi driver) and is a rework
> > >of the nozomi constify patch from Jan Engelhardt.
> > 
> > It's hard to find what you actually reworked...
> 
> No, just use interdiff and its easy :-) .. and btw
> I didn't say i did a full rewrite ;-)
> 
> > >-static struct pci_device_id nozomi_pci_tbl[] = {
> > >+static const struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
> > 
> > This is bogus.
> 
> In what way? First i tested this patch well (compiling and
> usage doesn't break a single thing) and second this (static
> const struct pci_device_id .. __devinitdata) can be found in many
> drivers.
> So, please explain why you think so.

__devinitdata is for non-const data.
__devinitconst is for const data.

You cannot mix const and non-const data in the same section,
if you do so gcc will complain.
It may build for you if all uses of __devinitdata in the
same source file is either const or non-const but when you
mix it then it breaks.

So please use the correct annotation.


> P.S.: btw this is the interdiff. Yes, its not big, but even
> then why not combine it with yours ;-)

We do small incremental steps whenever we can. The challenge is
often to split up patches and not to combine them.

Where we combine two patches this is when the second patch fix
a bug in the first patch.

	Sam
