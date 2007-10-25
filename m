Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXJYRTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXJYRTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXJYRTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:19:47 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:59059 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081AbXJYRTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:19:47 -0400
Date: Thu, 25 Oct 2007 20:19:42 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86: randomize brk() and RLIMIT_DATA
Message-ID: <20071025171942.pjff7jbpempfcuri@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Arjan van de Ven <arjan@infradead.org>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi> <20071025071324.2eac21d6@laptopd505.fenrus.org> <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
User-Agent: Mutt/1.5.16 (2007-10-15)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 16:46:26 +0200, Jiri Kosina wrote:
> On Thu, 25 Oct 2007, Arjan van de Ven wrote:
> 
> > > Would be neat if randomized brk and setrlimit(RLIMIT_DATA, ...)
> > > worked in a predictable way:
> > this isn't a valid case afaics; even on "traditional x86" (before we 
> > changed the address space layout, or even today if you have an unlimited 
> > stack rlimit) this isn't going to work. applications really shouldn't 
> > use (s)brk() but malloc(); you have to be able to fall back to mmap 
> > regardless of what you do.
> 
> I tend to agree here with Arjan. However it probably would make no harm to 
> make at least a little bit consisten behavior of setrlimit(), though it 
> has a little use in such cases.
> 
> Sami, does the patch below work for you?

Thanks, Jiri, now RLIMIT_DATA works as expected.

Using only RLIMIT_AS to limit processes' memory usage is not
very easy.  It includes also libraries mapped read-only,
I have to check/modify the limits when I update/add
libraries,...

Amazingly, I found a patch which seems to be just what I need:
http://marc.info/?l=linux-mm&m=118402827803338&w=4
Seems like that is not going to -mm or mainstream...

-- 
Do what you love because life is too short for anything else.

