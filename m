Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbZLOSOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbZLOSOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760235AbZLOSON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:14:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57626 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbZLOSOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:14:12 -0500
Date: Tue, 15 Dec 2009 19:14:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Emese Revfy <re.emese@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
 2.6.32-git-053fe57ac v2
Message-ID: <20091215181403.GB24406@elf.ucw.cz>
References: <cover.1260662994.git.re.emese@gmail.com>
 <20091214003836.GD7812@parisc-linux.org>
 <4B2595E7.701@gmail.com>
 <20091214021916.GB12196@linux-sh.org>
 <4B25E47C.1010803@gmail.com>
 <20091214112656.GB1959@elf.ucw.cz>
 <20091214080049.19930729@infradead.org>
 <20091214212526.GB9213@elf.ucw.cz>
 <20091214141757.73606259@infradead.org>
 <4B26BF14.3040709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B26BF14.3040709@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Arjan van de Ven wrote:
> > On Mon, 14 Dec 2009 22:25:26 +0100
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> >> On Mon 2009-12-14 08:00:49, Arjan van de Ven wrote:
> >>> On Mon, 14 Dec 2009 12:26:56 +0100
> >>> Pavel Machek <pavel@ucw.cz> wrote:
> >> I certainly object "constify ops... as much as possible". If it
> >> uglifies the code, it should not be done. If it is as simple as adding
> >> const to few lines, its probably ok.
> >>
> >> But .... the patch contained huge load of 
> >>
> >> -	int (* resume)()
> >> +	int (* const resume)()
> >>
> >> What is that?
> > 
> > the ops stuct instantiation itself should be const.
> > the members not so much; that makes no sense.
> 
> Consitfying the structure fields prevents direct modifications of runtime
> allocated ops structures therefore it gives a strong signal to the programmer
> that he's trying to do something undesired (this approach is in fact already
> used in the kernel, see: iwl_ops).

One const in structure declaration seems to be just enough, see:

const struct a {
	void (* f)(void);
	void (* const g)(void);
} s;

void h(void)
{
	struct a *p = &s;
	s.f = 0;
	s.g = 0;
	p->f = 0;
	p->g = 0;
}


delme.c: In function 'h':
delme.c:8: warning: initialization discards qualifiers from pointer target type
delme.c:9: error: assignment of read-only variable 's'
delme.c:10: error: assignment of read-only variable 's'
delme.c:12: error: assignment of read-only member 'g'

You get clean-enough warnings.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
