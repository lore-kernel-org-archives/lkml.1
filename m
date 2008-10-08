Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYJHHQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYJHHQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYJHHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:15:56 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:55708 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYJHHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:15:55 -0400
Date: Wed, 8 Oct 2008 09:15:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Matthew Wilcox <matthew@wil.cx>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
In-Reply-To: <1223422788.8195.45.camel@brick>
Message-ID: <Pine.LNX.4.64.0810080913150.19202@anakin>
References: <1223416391.8195.22.camel@brick> <1223417543.7484.7.camel@localhost.localdomain>
 <1223419166.8195.37.camel@brick> <20081007233315.GM25780@parisc-linux.org>
 <1223422788.8195.45.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, Harvey Harrison wrote:
> On Tue, 2008-10-07 at 17:33 -0600, Matthew Wilcox wrote:
> > On Tue, Oct 07, 2008 at 03:39:25PM -0700, Harvey Harrison wrote:
> > > As an example, in the write command handling in achba.c, a patch similar to the following
> > > (assumes the existence of a __be24 type somewhere):
> > 
> > What type could be defined to be '__be24'?  Would
> > 
> > typedef struct {
> > 	unsigned char data[3];
> > } __be24;
> 
> __packed

I don't think __packed would help here, as alignment(struct) ==
max(alignment(struct member)) == alignment(char).

Don't you want the __packed on the structure that embeds the __be24?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
