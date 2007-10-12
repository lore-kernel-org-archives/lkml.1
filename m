Return-Path: <linux-kernel-owner+w=401wt.eu-S1760342AbXJLRnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760342AbXJLRnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXJLRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:43:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36168 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbXJLRni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:43:38 -0400
Date: Fri, 12 Oct 2007 19:45:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Discardable strings for init and exit sections
Message-ID: <20071012174507.GA21193@uranus.ravnborg.org>
References: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0710121711120.21684@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 05:50:01PM +0100, Maciej W. Rozycki wrote:
>  We currently have infrastructure for discardable text and data, but no 
> such thing for strings.  This is especially notable for inline strings 
> such as ones used by printk() which are left behind resident in the memory 
> throughout the life of the system even though code referring to them has 
> been removed.

What is the actual benefit here expressed in real numbers?
For the __init/__exit notation that is yet only partially correct
we often see corner cases where one ask if it is really worth it.
Adding the discard functionality for strings seems like a logical extension
but there is a benefit/pain ratio to consider.

So real numbers please.

A few general notes to the patch.
1) We want to consolidate this in include/asm-generic/vmlinux*
somehow and this should be doen as a separate step.
2) If we introduce discardable strings then we shall in parallel
add build time checks so we catch strings marked as discardable
which is used outside a discardable compatible function.

	Sam
