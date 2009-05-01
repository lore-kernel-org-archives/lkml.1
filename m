Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbZEAXTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbZEAXTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbZEAXTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:19:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:48995 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZEAXTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:19:40 -0400
Date: Sat, 2 May 2009 01:21:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: "N" symbols and System.map
Message-ID: <20090501232149.GA28888@uranus.ravnborg.org>
References: <49FB7692.2000508@linux.intel.com> <m2preso1wl.fsf@igel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2preso1wl.fsf@igel.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 01:10:18AM +0200, Andreas Schwab wrote:
> "H. Peter Anvin" <hpa@linux.intel.com> writes:
> 
> > right now, we filter out symbols that nm tag N, meaning "debugging
> > symbols", from System.map.  However, at least on x86, the linker-generated
> > symbol _end is tagged N, and in fact is the only N in the entire image.
> >
> > Are there other architectures which would suffer if N were included in
> > System.map, or would that be a reasonable thing to do?
> 
> There should not be any N symbols unless you are using stabs debugging.

We have in vmlinux:
        .end : AT(ADDR(.end) - LOAD_OFFSET) {
                _end = .;
        }


And I see:
c1834000 N _end

This is the _only_ 'N' symbol in my vmlinux.

	Sam
