Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYANQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYANQsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYANQsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:48:32 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28972 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYANQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:48:31 -0500
X-Greylist: delayed 700 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jan 2008 11:48:31 EST
From: Paul Moore <paul.moore@hp.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc6-mm1 - oddness with IPv4/v6 mapped sockets hanging...
Date: Mon, 14 Jan 2008 11:36:40 -0500
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
References: <30887.1200209733@turing-police.cc.vt.edu> <7197.1200327338@turing-police.cc.vt.edu>
In-Reply-To: <7197.1200327338@turing-police.cc.vt.edu>
Organization: Hewlett Packard
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801141136.41140.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008 11:15:38 am Valdis.Kletnieks@vt.edu wrote:
> On Sun, 13 Jan 2008 02:35:33 EST, Valdis.Kletnieks@vt.edu said:
> > I'm seeing problems with Sendmail on 24-rc6-mm1, where the main Sendmail
> > is listening on ::1/25, and Fetchmail connects to 127.0.0.1:25 to inject
> > mail it has just fetched from an outside server via IMAP - it will often
> > just hang and not make any further progress. Looking at netstat shows
> > something interesting:
> >
> > % netstat -n -a -A inet | grep 25
> > tcp        0   5108 127.0.0.1:59355             127.0.0.1:25             
> >   ESTABLISHED
>
> The IPv6 is apparently a red herring - this morning I'm seeing the same
> problem with another totally separate pair of programs that are IPv4-only,
> hanging on loopback.

Are you still only seeing these problems on loopback?  I can't help but wonder 
if this is the skb_clone() problem where it wasn't copying skb->iif causing 
SELinux to silently drop the packets.  Then again, I'm not sure if there is a 
clone operation in the code path are going down.  From what I can remember I 
only saw clones on some of the multicast stuff but I'm still learning some of 
the darker corners of the stack.

If you've got some spare cycles, the kernel below should both have the 
clone/iif fix (it's in Linus' tree now) as well as some printks when errors 
occur so packet's are no longer silently dropped by SELinux.

 * git://git.infradead.org/users/pcmoore/lblnet-2.6_testing

-- 
paul moore
linux security @ hp
