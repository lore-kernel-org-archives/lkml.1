Return-Path: <linux-kernel-owner+w=401wt.eu-S935774AbZLQEav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935774AbZLQEav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936562AbZLQEa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:30:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55235 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935572AbZLQEa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:30:26 -0500
Date: Thu, 17 Dec 2009 04:30:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
Message-ID: <20091217043021.GV14381@ZenIV.linux.org.uk>
References: <20091216235617.GA12267@hexapodia.org> <20091217011932.GT14381@ZenIV.linux.org.uk> <4B29A8F3.3090306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B29A8F3.3090306@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:43:47PM -0500, Masami Hiramatsu wrote:
> Al Viro wrote:
> > On Wed, Dec 16, 2009 at 03:56:17PM -0800, Andrew Isaacson wrote:
> >> With CONFIG_KPROBES=y on Ubuntu 9.10 x86_64 default install, I get the
> >> following:
> >>
> >> Error: Your awk doesn't support charactor-class.
> >> Please try to use gawk.
> > 
> > Aside of the incorrect suggestion (you need not just gawk, you need that
> > thing installed as awk), the use of GNUisms in there is actually pointless
> > since encoding is bloody fixed.
> 
> Hmm, maybe "POSIX awk" will be a better suggestion, isn't it?

Not really.

Note that meaning of [:alpha:] depends on locale, and you are working
with fixed input, in fixed encoding.  So you *already* have a dependency
on locale and it's no better or worse way to express the set than A-Za-z
is.  With LANG=C both describe the set you are after; in other locales
neither is guaranteed to.  And having it set by caller of your script
is trivial.

IOW, you are actually misusing the language feature and while it's easy
to fix, the same fix will remove any benefits compared to universally
available alternative language feature.
