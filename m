Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbZJLRjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbZJLRjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZJLRjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:39:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:33204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757409AbZJLRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:39:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/aLb1jkFTa2aOJ88fH0gswj8p/yPhc1J0qnVIAOW
	aECooMfl5hRXaj
Subject: Re: *Really* bad I/O latency with md raid5+dm-crypt+lvm
From: Mike Galbraith <efault@gmx.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-kernel@vger.kernel.org, pernegger@gmail.com, arjan@infradead.org
In-Reply-To: <4AD341B2.6000704@wpkg.org>
References: <4AD341B2.6000704@wpkg.org>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 19:37:56 +0200
Message-Id: <1255369076.7162.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 16:48 +0200, Tomasz Chmielewski wrote:
> > Summary: I was hoping to use a layered storage setup, namely lvm on
> > dm-crypt on md raid5 for a new box I'm setting up, but that isn't
> > looking so good since a single heavyish writer will monopolise any and
> > all I/O on the "device". F. ex. while cp'ing a few GB of data from an
> > external disk to the array it takes ~10sec to run ls and ~2min to
> > start aptitude. Clueless attempts at a diagnosis below.
> 
> Did you try running strace to see where ls pauses?
> 
> Did you try running latencytop (and generally, top/htop while doing your 
> tests)?
> 
> 
> (...)
> 
> > Anyway, as soon as I copy something to the array or create a larger
> > (upwards of a few hundred MiB) tar archive the box becomes utterly
> > unresponsive until that job is finished. Even on the local console the
> > completion time for a simple ls or cat is of the order of tens of
> > seconds, just forget about launching emacs.
> > Now I know that people have been ranting about desktop responsiveness
> > for a while but that was very much an abstract thing for me until now.
> 
> I think the above (big latency when doing some bigger IO) is a general 
> Linux problem.

It would be interesting to test latest -rc.  Though it may prove to be
unrelated. the symptoms sound very much like a recent thread wrt writers
starving readers.

	-Mike

