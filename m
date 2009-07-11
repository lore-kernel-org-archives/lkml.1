Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZGKBcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZGKBcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 21:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZGKBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 21:32:16 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:53451 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZGKBcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 21:32:16 -0400
Date: Sat, 11 Jul 2009 02:32:12 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: once again, what's with "drivers/char/vr41xx_giu.c"?
Message-ID: <20090711013212.GA1252@sucs.org>
Mail-Followup-To: Andrew Price <andy@andrewprice.me.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.00.0907100505400.11274@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907100505400.11274@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Fri, Jul 10, 2009 at 05:06:49AM -0400, Robert P. J. Day wrote:
> 
>   on an occasional basis (after pulls), i get:
> 
> $ git diff
> diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
> deleted file mode 100644
> index e69de29..0000000
> $
> 
> not the first time i've seen that, either.  methinks that file got
> itself into a funny state.

No need to panic, it just looks like somebody left an empty file without
'git rm'ing it. When you run 'make distclean' for example, it removes
all empty files and leaves you with an unclean checkout. You can get the
(empty) file back by 'git checkout'ing the file. But yes, you shouldn't
have to. Anyway, CCing Linus to bring it to his attention.

I wonder if there is a better way to avoid this happening? If 'make
distclean' is assuming that no files should be empty then there should
probably be a guard against introducing empty files in the first place.
Can git warn us when we commit or merge changes which leave empty files,
for instance?

Andrew
