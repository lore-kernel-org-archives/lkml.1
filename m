Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbYJaPhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbYJaPhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYJaPh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:37:29 -0400
Received: from mail.suse.de ([195.135.220.2]:48860 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYJaPh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:37:27 -0400
From: Daniel Gollub <dgollub@suse.de>
Organization: SUSE Linux Products GmbH
To: Kai Henningsen <kai.extern@googlemail.com>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Date: Fri, 31 Oct 2008 16:37:23 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.27-rc6-8-default; KDE/4.1.2; x86_64; ; )
Cc: mtk.manpages@gmail.com, mtk.manpages@googlemail.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-man@vger.kernel.org, ltp-list@lists.sourceforge.net,
       "A.E. Brouwer" <aeb@win.tue.nl>
References: <20081023145054.998439866@marvin.suse.de> <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com> <20081031160248.2b95d0e8@desktop.khms.westfalen.de>
In-Reply-To: <20081031160248.2b95d0e8@desktop.khms.westfalen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810311637.25371.dgollub@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2008 16:02:48 Kai Henningsen wrote:
> Am Fri, 24 Oct 2008 17:53:25 -0500
>
> schrieb "Michael Kerrisk" <mtk.manpages@googlemail.com>:
> > Hi Daniel,
> >
> > On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub@suse.de>
> >
> > wrote:
> > > EINVAL bufsiz is not positive.
> >
> > The EINVAL error was added to man-pages-1.18 in 1997 (even though, as
> > you note, the type was "size_t").  I suspect (this was well before I
> > had any association with man-pages) that was done to reflect kernel
> > reality (since one could bypass glibc invoke the syscall directly),
> > but obviously it is inconsistent with the prototype.
>
> Actually, it's not inconsistent as described, though perhaps that is
> unintentional. "Not positive" isn't the same as "negative", as zero
> isn't positive either, and zero is certainly a possible value of an
> unsigned type

True.

But there is still the problem for the ltp syscall test "readlink03", when 
using the glibc "readlink" interface, by calling readlink with a buffer size 
of "-1".

Calling "-1" seems to be a valid code/error-path in the linux syscall 
"readlink", since there is a check for less-equal zero.

But the less zero, condition can't be reached via the glibc "readlink" 
interface since this would cause fortify-check to fail (when buliding with -
D_FORITFY_SOURCE=2).

To "workaround" the fortify check, by not compiling the testcase with -
D_FORTIFY_SOURCE=2, or trying to test the linux readlink interface by calling 
directly syscall() in the testcase ... both suggestion are just workarounds - 
no real solutions.

We could also just remove the testcase of buffer size "-1".

The problem is still, how to test the "readlink" syscall in LTP?

best regards,
Daniel
