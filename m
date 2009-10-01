Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZJAM5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZJAM5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZJAM5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:57:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56237 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZJAM5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:57:10 -0400
Date: Thu, 1 Oct 2009 13:56:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@ksplice.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH 2/2] arm: Clean up linker script using new linker
	script macros.
Message-ID: <20091001125657.GA26910@n2100.arm.linux.org.uk>
References: <1254345935-15958-1-git-send-email-tabbott@ksplice.com> <1254345935-15958-3-git-send-email-tabbott@ksplice.com> <20090930213924.GB15732@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930213924.GB15732@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 11:39:25PM +0200, Sam Ravnborg wrote:
> On Wed, Sep 30, 2009 at 05:25:35PM -0400, Tim Abbott wrote:
> > From: Nelson Elhage <nelhage@ksplice.com>
> > 
> > This patch is mostly a straightforward translation. The primary side
> > effect to the resulting vmlinux should be to increase the alignment on
> > the initramfs to the standard PAGE_SIZE from 32 bytes.
> > 
> > Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> > ---
> >  arch/arm/kernel/vmlinux.lds.S |   75 +++++++++++-----------------------------
> >  1 files changed, 21 insertions(+), 54 deletions(-)
> > 
> >  
> > -	.bss : {
> > -		__bss_start = .;	/* BSS				*/
> > -		*(.bss)
> > -		*(COMMON)
> > -		__bss_stop = .;
> > -		_end = .;
> 
> Where is _end in the new layout?
> I think we lost it.

You're right - this will cause a build failure since _end is used in
several core ARM files.  Tim?

PS, please ensure that all patches are at the very least build tested,
or say when they aren't.
