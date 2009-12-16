Return-Path: <linux-kernel-owner+w=401wt.eu-S934687AbZLPIHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687AbZLPIHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 03:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934676AbZLPIHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 03:07:06 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39665 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933679AbZLPIHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 03:07:02 -0500
Date: Wed, 16 Dec 2009 09:06:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Emese Revfy <re.emese@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for
 2.6.32-git-053fe57ac v2
Message-ID: <20091216080653.GU24406@elf.ucw.cz>
References: <4B2595E7.701@gmail.com>
 <20091214021916.GB12196@linux-sh.org>
 <4B25E47C.1010803@gmail.com>
 <20091214112656.GB1959@elf.ucw.cz>
 <20091214080049.19930729@infradead.org>
 <20091214212526.GB9213@elf.ucw.cz>
 <20091214141757.73606259@infradead.org>
 <4B26BF14.3040709@gmail.com>
 <20091215181403.GB24406@elf.ucw.cz>
 <4B281BA4.8090806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B281BA4.8090806@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > One const in structure declaration seems to be just enough, see:
> > 
> > const struct a {
> > 	void (* f)(void);
> > 	void (* const g)(void);
> > } s;
> > 
> > void h(void)
> > {
> > 	struct a *p = &s;
> > 	s.f = 0;
> > 	s.g = 0;
> > 	p->f = 0;
> > 	p->g = 0;
> > }
> > 
> > 
> > delme.c: In function 'h':
> > delme.c:8: warning: initialization discards qualifiers from pointer target type
> > delme.c:9: error: assignment of read-only variable 's'
> > delme.c:10: error: assignment of read-only variable 's'
> > delme.c:12: error: assignment of read-only member 'g'
> > 
> > You get clean-enough warnings.
> 
> Notice how you got an error for line 12 (p->g assignment) but no warning or error
> at all for line 11 (p->f assignment). This example illustrates what I was explaining
> so far:

And notice how you get warning for line 8? That's what I'm talking
about, and it should be enough to make the developer think about what
he's doing. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
