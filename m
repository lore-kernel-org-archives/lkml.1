Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXGLXEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXGLXEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXGLXEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:04:32 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:53627 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbXGLXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:04:32 -0400
Message-ID: <4696B35D.1030808@gmail.com>
Date: Fri, 13 Jul 2007 01:03:57 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.22.1
References: <20070710200637.GA5881@kroah.com> <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <20070712184106.GA22849@kroah.com> <29495f1d0707121146k7b3a7175l1fcb40877e59cfaf@mail.gmail.com> <20070712185219.GR4306@sequoia.sous-sol.org>
In-Reply-To: <20070712185219.GR4306@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2007 08:52 PM, Chris Wright wrote:

> Nish, I think you might be the only user ;-)  I never figured out a nice 
> way to do this w/out having a coherency issue (well, triggers aside). 
> Ideally git would allow for something more transparent than alternatives,
> actual moving view to another tree.  It's possible with links, but that
> seems just dirty.  Short of that, do folks find the tree useful?  If so,
> I can work on some better automation to keep it up-to-date.

I tried this tree a while ago but at the time it had a problem with tags 
(http://lkml.org/lkml/2007/4/14/177). I just recloned and see that's now 
fixed...

I'm rolling my own since then though. Not sure, but perhaps it's interesting 
to someone: when Linus tags a release from his repo I branch of the -stable 
branch myself:

$ git checkout -b v22 v2.6.22

and then (following advice from Junio Hamano) add the following stanza to 
.git/config:

===
[branch "v22"]
         remote = linux-2.6.22.y
         merge = refs/heads/master
[remote "linux-2.6.22.y"]
         url = 
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
         fetch = refs/heads/master
===

(the url = is one line, but is wrapping).

When on this v22 branch, a simple "git pull" then updates from the stable 
tree. It's been working nicely for me. The manual .git/config editing is a 
little awkard perhaps but for all I know I could do so via some well-chosen 
git commands.

Rene.

