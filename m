Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbYETQko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbYETQko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYETQke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:40:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbYETQkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:40:33 -0400
Date: Tue, 20 May 2008 11:42:09 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: aperture_64: use symbolic constants
Message-ID: <20080520154209.GD542@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20080519123952.GA23118@elf.ucw.cz> <20080519125425.GD13546@elte.hu> <20080520142717.GA22794@elf.ucw.cz> <20080520150604.GD4843@redhat.com> <20080520153215.GA5368@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520153215.GA5368@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:32:15PM +0200, Pavel Machek wrote:

 > > Instead of making this an inline, we could add it to the agpgart code
 > > and export it, and have the gart-iommu code call it.
 > > You can't build the IOMMU code without agpgart anyway, and having this inlined
 > > in both places seems a bit wasteful.
 > > Additionally, it would mean not having a function in a header file,
 > > which always strikes me as a wrong thing to do.
 > 
 > Can you elaborate? Yes, it would be nicer if this went to .c
 > somewhere, but aperture_64.c seems unsuitable (we need it on 32-bit,
 > too, right?)... plus it was __init in one place, and __devinit in the
 > other, so I figured out "inline it so that it works automagically".
 > 
 > Plus, I don't think it should go into drivers/agp, as iommu code in
 > arch/x86/kernel seems to be able to work without that...?

If you enable IOMMU, you _have_ to enable AGP.  (well, you don't have to,
it does a 'select AGP' for you when you enable it :-)

It does this because the agpgart driver needs to know how much of the
aperture has been stolen for IOMMU use, and I think it already uses some
functions from that driver already.

	Dave

-- 
http://www.codemonkey.org.uk
