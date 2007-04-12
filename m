Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXDLJLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXDLJLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXDLJLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:11:22 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:57270 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbXDLJLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:11:22 -0400
Date: Thu, 12 Apr 2007 11:11:20 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412091120.GA15666@uhulinux.hu>
References: <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <461D2AB8.5080902@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 11:36:40AM -0700, H. Peter Anvin wrote:
> Egmont Koblinger wrote:
> >+static int is_zero_width(long ucs)
> >+{
> >+  static const struct interval zero_width[] = {
> /* lots */
> >+  };
> 
> I'm still unhappy about these large search tables in the kernel, not 
> because they take a huge amount of space (it's not that much), but 
> because they're invariably going to be stale, as they're Unicode-version 
> dependent.

I don't think width information for characters in BMP is going to change
that often.

By the way, a note about the size: the larger one of the two tables is
unused and hence optimised away by the compiler. I just left in the source
so that it only takes a minor modification for people go get a different
sane behavior (ie. ignore combining chars). So only the small table, with 11
pairs of longs (88 bytes) are compiled to the kernel.

> At least please put them in a separate .c file and include a script to 
> generate them clean from UnicodeData.txt.

I'll look at it, but I didn't want to alter the building procedure, modify
Makefiles... Or do you mean I should only ship the generated .c file plus
the script, instead of the (1MB) UnicodeData.txt and generating it compile
time? Sounds reasonable...

> Besides, would it not make more sense to have a single table with the 
> width information, if you insist on having one, instead of multiple ones?

I've been thinking on it and I'm not sure which one the right way is. The
reason for choosing this was probably that this way information that is not
used by the code can be omitted by the compiler.



-- 
Egmont
