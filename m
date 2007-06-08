Return-Path: <linux-kernel-owner+w=401wt.eu-S967810AbXFHDue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967810AbXFHDue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967342AbXFHDu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:50:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51141 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966962AbXFHDuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:50:25 -0400
Date: Fri, 8 Jun 2007 09:19:58 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
Message-ID: <20070608034958.GA10728@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com> <466749C8.2010700@goop.org> <46674C96.7090104@zytor.com> <46674F68.6030100@goop.org> <4667547B.8080502@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667547B.8080502@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 05:42:35PM -0700, H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
> > 
> > Certainly, but much harder to implement.  The ELF parser needs to be
> > prepared to move itself around to get out of the way of the ELF file. 
> > It's a fairly large change from how it works now.
> > 
> 
> It doesn't if we simply declare that a certain chunk of memory is
> available to it, for the case where it runs in the native configuration.
> Since it doesn't have to support *any* ELF file, just the kernel one,
> that's an option.
> 
> On the other hand, I guess with the decompressor/ELF parser being PIC,
> one would simply look for the highest used address, and relocate itself
> above that point.  It's not really all that different from what the
> decompressor does today, except that it knows the address a priori.
> 

One would not know highest used address until ELF headers have been 
parsed. May be it is two step movement. First decompress ELF.gz and 
ELF parser can be at the end of decompressed data. Then it can parse
the ELF headers and move itself out of the ELF header destination memory
and then load the elf segments at appropriate place.

One will have to be little careful while moving ELF parser or while
decompressing the file to a temporary buffer so that we don't stomp over
any other data loaded by boot-loader (like kexec does) or we don't go beyond
the memory bounds which might have been created in the case of using kdump.

Thanks
Vivek
