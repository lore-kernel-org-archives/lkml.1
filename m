Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYHLWFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYHLWFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYHLWFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:05:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50057 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752133AbYHLWFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:05:13 -0400
Date: Tue, 12 Aug 2008 22:47:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080812224730.0e668dee@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk>
	<87ej4u9nf5.fsf@devron.myhome.or.jp>
	<alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
	<87proe81c1.fsf@devron.myhome.or.jp>
	<alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 13:05:43 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 13 Aug 2008, OGAWA Hirofumi wrote:
> > 
> > However, there are some similar stuff: ->st_size, ->st_nlink and
> > ->st_ino in stat() (cp_old_stat()). Maybe EOVERFLOW is the reason for
> > consistency...
> 
> .. I actually had an old binary that triggered that case (actually, it was 
> O_LARGEFILE in open()), and didn't work as a result. I only needed to run 
> it once, so I literally hacked up a once-time-use kernel that just removed 
> the EOVERFLOW in open.
> 
> So no, I'm not a fan of EOVERFLOW at all. Not in readdir(), not really 
> anywhere else. 

In a lot of places the standard mandates it to ensure you don't get nasty
suprises. There are places where during the LFS work people found apps
whose large file response was unpleasant - things like "get the file
length, reduce it to an exact number of records long with ftruncate in
case we got a partial record write somewhere" do horrible things when the
length wraps.

That said there is nothing that says we can't have a 'posix_me_harder'
sysfs control for such things. The standards say what should occur in the
normal situation not what should occur if you intentionally move out of
the standard definition.

Alan

