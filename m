Return-Path: <linux-kernel-owner+w=401wt.eu-S965706AbXEWP4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965706AbXEWP4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762975AbXEWP4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:56:40 -0400
Received: from [216.16.235.2] ([216.16.235.2]:57361 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758472AbXEWP4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:56:39 -0400
X-Originating-Ip: 99.246.112.70
Date: Wed, 23 May 2007 11:55:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Aubrey Li <aubreylee@gmail.com>, Christoph Lameter <clameter@sgi.com>,
       Bernhard Walle <bwalle@suse.de>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
In-Reply-To: <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
Message-ID: <Pine.LNX.4.64.0705231153360.7749@localhost.localdomain>
References: <20070521151525.GA581@suse.de>  <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
  <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com>
 <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, James Bottomley wrote:

> I'll defer to Mark on this one.  However, please remember that you
> can't just blindly remove GFP_DMA ... there are some cards which
> require it.
>
> Aacraid is one example ... it has a set of cards that can only DMA
> to 31 bits.  For them, the GFP_DMA is necessary:  The allocation in
> question is a scatterlist, which must be within the device DMA mask.

a question i asked a while back, and still haven't seen an answer for
-- given this in include/linux/gfp.h:

  #define GFP_DMA         __GFP_DMA

is there a qualitative difference between these two macros?  is there
*supposed* to be?  if there isn't, one would think that just one
variation would be sufficient.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
