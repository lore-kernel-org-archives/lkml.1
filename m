Return-Path: <linux-kernel-owner+w=401wt.eu-S1764106AbYEBCI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764106AbYEBCI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756735AbYEBCIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:08:19 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:47154
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756019AbYEBCIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:08:18 -0400
Date: Thu, 1 May 2008 19:08:15 -0700
From: Phil Oester <kernel@linuxace.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roth <ryanroth@sbcglobal.net>, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults onMacBookStarting With 2.6.24.5 Kernel
Message-ID: <20080502020815.GA5155@linuxace.com>
References: <bug-10586-10286@http.bugzilla.kernel.org/> <20080501130444.cc5c63e8.akpm@linux-foundation.org> <86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com> <20080501133003.be723364.akpm@linux-foundation.org> <86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com> <481A5276.4040607@sbcglobal.net> <20080501170239.9b740877.akpm@linux-foundation.org> <481A5A94.2080400@sbcglobal.net> <20080501173408.384b4fc3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501173408.384b4fc3.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 05:34:08PM -0700, Andrew Morton wrote:
> On Thu, 01 May 2008 17:04:36 -0700
> Ryan Roth <ryanroth@sbcglobal.net> wrote:
> 
> > Since this last boot I have only got these:
> > 
> > > May 1 16:26:25 kernel: gnome-power-man[3112]: segfault at 0 ip 410fda 
> > > sp 7fff4712c870 error 4 in gnome-power-manager[400000+47000]
> > > May 1 16:26:25 kernel: gnome-power-man[3116]: segfault at 0 ip 410fda 
> > > sp 7fff2959cce0 error 4 in gnome-power-manager[400000+47000]
> > > May 1 16:26:25 kernel: gnome-power-man[3119]: segfault at 0 ip 410fda 
> > > sp 7fffc7671db0 error 4 in gnome-power-manager[400000+47000]
> 
> OK.
> 
> Well I don't know what the heck to do about that.  It could be that we've
> gone and changed the contents of (say) an acpi /proc file, and this happens
> to cause your particular version of gnome-power-manager to take a different
> (and buggy) codepath, so it crashes.  Or something like this.
> 
> I hate to do this to you, but our best hope for getting to the bottom of
> this is for you to run a git bisection search to find out what we did which
> triggered this.  http://www.kernel.org/doc/local/git-quick.html has some
> instructions.
> 
> Or you could go the other route and work out where and why
> gnome-power-manager is crashing.
> 
> You could try upgrading (or downgrading) your gnome-power-manager version,
> see if that affects things.
> 
> Does the problem affect only gnome-power-manager?

FWIW, I recently upgraded some boxes to 2.6.24.x, and started seeing tons of
qmail segfaults, which look remarkably similar to the above problem.  2.6.21
did not exhibit this issue.

May  1 22:06:03 mail80 kernel: qmail-smtpd[5319]: segfault at 0 ip 4884b473 sp fffeec1c error 4 in libc-2.6.so[487dd000+14e000]
May  1 22:06:03 mail80 kernel: qmail-smtpd[5491]: segfault at 0 ip 4884b473 sp ffb7179c error 4 in libc-2.6.so[487dd000+14e000]
May  1 22:06:03 mail80 kernel: qmail-smtpd[4669]: segfault at 0 ip 4884b473 sp fff3135c error 4 in libc-2.6.so[487dd000+14e000]
May  1 22:06:05 mail80 kernel: qmail-smtpd[5906]: segfault at 0 ip 4884b473 sp ffe1b24c error 4 in libc-2.6.so[487dd000+14e000]
May  1 22:06:07 mail80 kernel: qmail-smtpd[5898]: segfault at 0 ip 4884b473 sp ffe4e27c error 4 in libc-2.6.so[487dd000+14e000]
May  1 22:06:11 mail80 kernel: qmail-smtpd[5840]: segfault at 0 ip 4884b473 sp ffe04a2c error 4 in libc-2.6.so[487dd000+14e000]

Phil
