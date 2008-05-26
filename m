Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYEZKiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYEZKiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYEZKhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:37:53 -0400
Received: from lazybastard.de ([212.112.238.170]:45967 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYEZKhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:37:52 -0400
Date: Mon, 26 May 2008 12:37:39 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Davi Leal <davi@leals.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: I am a volunteer
Message-ID: <20080526103738.GA20623@logfs.org>
References: <200805251812.41552.davi@leals.com> <200805252023.22510.davi@leals.com> <20080525194721.GH6749@1wt.eu> <200805252244.53524.davi@leals.com> <20080525210051.GA5609@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080525210051.GA5609@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 23:00:51 +0200, Willy Tarreau wrote:
> 
> reading code is 100% compatible with time constraints, as there is no
> deadline. You can even say that a bug that you don't look at may stay
> there for years. And quite frankly, spending more than one hour every
> evening on code is generally enough to give you a headache. But you
> will progress very quickly.

When looking for something to improve, it often helps to write a new
code checker or run an existing one.  If you don't know anything better,
you can write a script that runs Lindent, takes the diff between the
original file and the Lindent version and sorts files by diff size.

The point of this excercise is not to run Lindent on every file and
submit patches for that.  But most code checkers, even a stupid one like
this, tend to warn about the same files.  And those files tend to be
ones that are badly maintained, have often been bitrotting for some
years and could use some work.  Even better, they are in such a bad
shape that it's hard not to improve things.

For example, I once found something like the below in drivers/cdrom/:

#define FOO()	\
	bar();	\
	bar();	\
	bar();	\
	bar();

...

	if (baz)
		FOO();

So after macro extention, three of the four statements are always
executed and only one is conditional.  Since I didn't have hardware to
test things I didn't change the code.  My guess is the code still exists
unchanged.

Jörn

-- 
All models are wrong. Some models are useful.
-- George Box
