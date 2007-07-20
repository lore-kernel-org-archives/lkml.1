Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbXGTRI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbXGTRI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932542AbXGTRHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:07:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42163 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474AbXGTRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:07:46 -0400
Date: Fri, 20 Jul 2007 11:07:43 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Message-ID: <20070720170743.GF14791@parisc-linux.org>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4699EEA9.6070709@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 10:53:45AM +0100, Simon Arlott wrote:
> Do people ever check what Lindent does?
[...]
> > -out1:
> > +      out1:
> 
> NAK: A perfectly valid non-indented label is now indented by 6 spaces.

I tracked down why indent does this.  It's actually hard-coded to indent
by 2 fewer columns than the current code indentation.  I've patched it
to allow specifying either an absolute column, or a column relative to
the current indentation level.

Patch here:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=433956

Of course, we can't add this flag to Lindent until it's widely
circulating amongst the distributions.  Perhaps we can add this to
Lindent in the meantime:

sed -i -e 's/^\t*      \(\w*:\)/ \1/' "$@"

which will replace the leading tabs and spaces with one space.
It should leave case labels unmolested, as they should be indented with
tabs, not 6 spaces.

Any regexp ninjas want to have a go at something better?

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
