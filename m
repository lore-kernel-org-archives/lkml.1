Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbZLPWWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbZLPWWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZLPWWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:22:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59941 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762625AbZLPWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:22:36 -0500
Message-ID: <4B295E12.1000408@gmail.com>
Date: Wed, 16 Dec 2009 23:24:18 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arjan van de Ven <arjan@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <4B2595E7.701@gmail.com> <20091214021916.GB12196@linux-sh.org> <4B25E47C.1010803@gmail.com> <20091214112656.GB1959@elf.ucw.cz> <20091214080049.19930729@infradead.org> <20091214212526.GB9213@elf.ucw.cz> <20091214141757.73606259@infradead.org> <4B26BF14.3040709@gmail.com> <20091215181403.GB24406@elf.ucw.cz> <4B281BA4.8090806@gmail.com> <20091216080653.GU24406@elf.ucw.cz>
In-Reply-To: <20091216080653.GU24406@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> One const in structure declaration seems to be just enough, see:
>>>
>>> const struct a {
>>> 	void (* f)(void);
>>> 	void (* const g)(void);
>>> } s;
>>>
>>> void h(void)
>>> {
>>> 	struct a *p = &s;
>>> 	s.f = 0;
>>> 	s.g = 0;
>>> 	p->f = 0;
>>> 	p->g = 0;
>>> }
>>>
>>>
>>> delme.c: In function 'h':
>>> delme.c:8: warning: initialization discards qualifiers from pointer target type
>>> delme.c:9: error: assignment of read-only variable 's'
>>> delme.c:10: error: assignment of read-only variable 's'
>>> delme.c:12: error: assignment of read-only member 'g'
>>>
>>> You get clean-enough warnings.
>> Notice how you got an error for line 12 (p->g assignment) but no warning or error
>> at all for line 11 (p->f assignment). This example illustrates what I was explaining
>> so far:
> 
> And notice how you get warning for line 8? That's what I'm talking
> about, and it should be enough to make the developer think about what
> he's doing. 
> 									Pavel

You are talking about in-kernel ops structures whose constness will
prevent bad code from being written. On the other hand, I was talking
about new code yet-to-enter the kernel where the developer has no indication
that he should be using a const ops structure (other than perhaps checkpatch
except apparently things easily fall through the cracks, see my series for
file_operations) and this is where const structure fields would help.

In any case, as I indicated already, I will remove these parts from the patches.
--
Emese
