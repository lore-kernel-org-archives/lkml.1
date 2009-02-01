Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZBAK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZBAK7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZBAK7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:59:08 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:38310 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZBAK7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:59:07 -0500
X-Greylist: delayed 3222 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Feb 2009 05:59:07 EST
Date: Sun, 1 Feb 2009 11:59:04 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ankit Jain <me@ankitjain.org>, viro@zeniv.linux.org.uk,
       hch@infradead.org, linux-fsdevel@vger.kernel.org, mfasheh@suse.com,
       joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Subject: Re: [PATCH] fs: Add new pre-allocation ioctls to vfs for compatibility
 with legacy xfs ioctls
In-Reply-To: <49857BEB.30404@panasas.com>
Message-ID: <Pine.LNX.4.64.0902011151180.20875@anakin>
References: <4980C71F.1010804@ankitjain.org> <200901310138.34164.arnd@arndb.de>
 <20090130171423.f99c88d0.akpm@linux-foundation.org> <200901310248.42820.arnd@arndb.de>
 <49856FE6.8020601@panasas.com> <Pine.LNX.4.64.0902011104320.20875@anakin>
 <49857BEB.30404@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009, Boaz Harrosh wrote:
> Geert Uytterhoeven wrote:
> > On Sun, 1 Feb 2009, Boaz Harrosh wrote:
> >> Arnd Bergmann wrote:
> >>> +struct space_resv {
> >>> +	__s16		l_type;
> >>> +	__s16		l_whence;
> >>> +	__s64		l_start;
> >>> +	__s64		l_len;		/* len == 0 means until end of file */
> >>> +	__s32		l_sysid;
> >>> +	__u32		l_pid;
> >>> +	__s32		l_pad[4];	/* reserve area			    */
> >>> +};
> >> What about telling the compiler exactly what you said above, just
> >> to be sure we all mean the same thing. (And as documentation for new
> >> comers):
> >>
> >> +struct space_resv_64 {
> >> +	__s16		l_type;
> >> +	__s16		l_whence;
> >> +	__u32		reserved;
> >> +	__s64		l_start;
> >> +	__s64		l_len;		/* len == 0 means until end of file */
> >> +	__s32		l_sysid;
> >> +	__u32		l_pid;
> >> +	__s32		l_pad[4];	/* reserve area			    */
> >> +} __packed;
> > 
> > Because the compiler will assume all fields are always unaligned and will use very
> > suboptimal code to access them?
> 
> This discussion comes up every once in a while. I'm using an old FC7 compiler
> (gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-27)) And tests show that when the layout
> of a structure is exactly the same the "__packed" on structure declarations does
> nothing. It only starts to affect when there are real differences in alignment.
> Also tests with gcc 3.4.x showed the same effect.
> 
> On previous discussions no one could come forward and say what compiler version
> breaks when __packed is applied on structure definition. I'm afraid your statement
> above is a myth.

FC7, targeting ia32? Sure, ia32 has no alignment restrictions.
Try e.g. MIPS.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
