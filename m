Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0BNMoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 07:44:00 -0500
Received: from poutre.nerim.net ([62.4.16.124]:65043 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0BNMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 07:43:59 -0500
Date: Sun, 14 Feb 2010 13:43:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>, mirrors@kernel.org,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100214134355.056d95ab@hyperion.delvare>
In-Reply-To: <20100214094940.GB17999@1wt.eu>
References: <4B744E13.8040004@kernel.org>
	<20100211205129.GA26105@elf.ucw.cz>
	<20100213181008.479509f5@hyperion.delvare>
	<4B773B31.1020802@lougher.demon.co.uk>
	<20100214102308.1d1d6fff@hyperion.delvare>
	<20100214094940.GB17999@1wt.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salut Willy,

On Sun, 14 Feb 2010 10:49:40 +0100, Willy Tarreau wrote:
> On Sun, Feb 14, 2010 at 10:23:08AM +0100, Jean Delvare wrote:
> > I am not claiming that gzip is dead. It is very useful and it is there
> > to stay for the years to come, no doubt about that. What I'm saying is
> > that it isn't the best choice for large files to be downloaded from a
> > remote server.
> 
> Well, I personally like to be able to simply run "less patch-2.6.27.45.gz"
> and have it transparently uncompressed and dumped on my terminal. It
> doesn't do that on bz2. We could find multiple examples.

This only underlines what I just wrote: the purpose of gzip is
different from the purpose of bzip2 or lzma. Transparent decompression
makes sense for the former but little for the latter two. But this
doesn't mean everyone must make all their files available in .gz format.
Not every file, and not everyone, needs transparent decompression. It
makes sense on patch files, but not on tarballs. You have the need, but
I don't. Furthermore, the fact that your local usage of patch files is
more convenient if they come in .gz format doesn't imply that this is
the format in which you have to download them. You are free to repack
files after downloading them. This can even be easily automated.

hpa seems to be very reluctant to the idea, but one thing I had in mind
was that patches could be in .gz format and tarballs in .xz, for
example. Having to stick to a common strategy for all the files seems
suboptimal, given their different natures and uses.

(And for completeness: on my distribution, the bzip2 package comes with
a little helper script named bzless, which does exactly what you want
for bzip2-compressed patches. But I wouldn't recommend using it...)

> Another thing comes to mind, because I've been beaten by this in the
> past. People working in enterprises where the internet access passes
> via mandatory proxies coupled with anti-virus can often download many
> things but not binaries that can't be analysed. At this time, I could
> only download tar.gz but not .bz2. And please don't tell me I have to
> go to the admin to tell him to change his proxy's configuration, you
> can't do that when you work as a consultant for a 20000 persons group
> where products are selected after 6-12 months of testing and managed
> by different people from those who qualify them.

I've been working in such environments in the past, so I see what you
mean. And I do not disagree that the format in which projects make
their files available can be more or less convenient in such
situations. For example, I remember being deeply annoyed by projects
not releasing tarballs, because I simply couldn't access CVS
repositories.

That being said, I also don't think that you can put all the burden of
bad company policies on the shoulder of open source software providers.
If someone worked in a company where even .gz compressed files can't be
downloaded, we wouldn't ask kernel.org to provide uncompressed files on
top of .gz and .bz2, would we? There is a trade-off to be found between
flexibility of access and disk and network usage.

It should be possible to retrieve the kernel sources using git over
HTTP these days anyway, right? Or are firewalls frequently blocking
this as well?

> In my opinion, .xz is a very good option to replace .bz2 as it will
> bring advantages without downsides. But .gz should stay as it has
> been available from day 1, at least for all people who may have
> trouble with .xz for whatever reason. If it has not been a problem
> for the last 16 years, I don't see why it would suddenly become one.

People have been using Windows for the last 16 years, it has not been a
problem, so I don't see why it would suddenly become one. Let's stop
working on an alternative. That way we don't have to decide which
compression format to use! Problem solved ;)

Seriously: things can become a problem over time even if they were not
one initially, and needs may evolve as well. The Linux kernel releases
have grown very big compared to the early days, and we release more
often, and new compression technologies exist and are getting widely
adopted. You don't have to stand in front of the wall to declare that
there's a problem. Just improving the user experience is worth the
change sometimes.

That being all said, I don't fundamentally disagree with you: just
replacing .bz2 with .xz would be fine with me. Really, my main concern
is the file count in directory v2.6/, much more than the compression
formats being used.

-- 
Jean Delvare
