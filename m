Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbXFCP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbXFCP5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXFCP5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 11:57:14 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:49930 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXFCP5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 11:57:13 -0400
Date: Sun, 3 Jun 2007 17:56:49 +0200
From: Wouter Verhelst <wouter@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] m68k: runtime patching infrastructure
Message-ID: <20070603155649.GB28228@grep.be>
References: <20070528191630.377693320@mail.of.borg> <20070528191715.352919509@mail.of.borg> <20070529173818.fd94ae81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529173818.fd94ae81.akpm@linux-foundation.org>
X-Speed: Gates' Law: Every 18 months, the speed of software halves.
Organization: The Debian Project, http://www.debian.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 05:38:18PM -0700, Andrew Morton wrote:
[...]
> > +struct mod_arch_specific {
> > +	struct m68k_fixup_info *fixup_start, *fixup_end;
> > +};
> 
> Here we use struct m68k_fixup_info.
[...]
> > +struct m68k_fixup_info {
> > +	enum m68k_fixup_type type;
> > +	void *addr;
> > +};
> 
> and later we define it.
> 
> How come it doesn't spit warnings?

Because otherwise you couldn't create linked lists:

struct foo {
  void* data;
  struct foo* next;
};

At that point it hasn't been defined yet but it is being used. This is
legal, so the compiler can't create a warning for that.

Which is not to say that it's a nice coding style, but that's a
different matter.

-- 
Shaw's Principle:
	Build a system that even a fool can use, and only a fool will
	want to use it.
