Return-Path: <linux-kernel-owner+w=401wt.eu-S1752333AbZBQESG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbZBQESG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 23:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZBQERy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 23:17:54 -0500
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:24626 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750778AbZBQERy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 23:17:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jK2HWIj47FXu4IUs131ZI05c379YaGYAypRTGLgJlK9r9SRsPij1sPZElzD5j4bpQJqtr/OK5vKwkl0rR+MXEMx63xW/wvfEwi8640ONfFZL8OJPqPmUDVH6RKo5I8K3zl34802tzBvHJ1Xc5V0I2X15VdZvjGjZbYXHzbjcyrc=  ;
X-YMail-OSG: kAsI95kVM1m2YrL.Owmtt9xyvuZL47fERqTg2hQbfUYa.OeXWczisziwYIiQJ_yE8ZIn5N3xZ7KZLT4X7l.qFCZ8EcdvdQ5QGp5zvgeJa3Cz_6uxaoMrXnoxi1ifV4mhfE4fKhCcKOfzMMyMZ997LAtw66so4oL6ZgrJTswP.J2iPJVlhQrSD2YlbEyO6_K_Q36Xn6iUExCFZXxRDZm.37_bctSmnUE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>, stable@kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
Date: Tue, 17 Feb 2009 15:17:23 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org, Federico Cuello <fedux@lugmen.org.ar>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
References: <20090127093533.GB7037@charite.de> <20090209134958.GP27548@charite.de> <20090215134235.GB15398@charite.de>
In-Reply-To: <20090215134235.GB15398@charite.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171517.23980.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 February 2009 00:42:35 Ralf Hildebrandt wrote:
> * Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>:
> > > This patch seems good to me. If you would care to add a changelog and
> > > Signed-off-by: line, then we could get it merged?
> > >
> > > I am not too sure about this bug. I have reproduced a strange hang with
> > > ext4 (which does include sys_sync and write_cache_pages traces), and
> > > also turned up a lockdep report. Also, we haven't seen any reports of
> > > this problem on other filesystems. So it could be an ext4 bug.
> > >
> > > Your traces also have lots of tasks hung waiting for page lock. It is
> > > possible that wakeups get lost, which is fixed by this commit in
> > > mainline
> > > 777c6c5f1f6e757ae49ecca2ed72d6b1f523c007
> > >
> > > Which might also be your bug.
> > >
> > >
> > > Any chance you can test this patch (as well as the existing patches
> > > you are using to fix write_cache_pages?).
> >
> > I could test 2.6.28.4
>
> Still there in 2.6.28.5 :(

I believe it is basically a deadlock in ext4 due to the cyclic writeback
change.

http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=2acf2c261b823d9d9ed954f348b97620297a36b5

ext4 guys, is this correct? Is there a minimal fix that can be made for
.stable kernels?

