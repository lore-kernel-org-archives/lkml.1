Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXHRQqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXHRQqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 12:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbXHRQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 12:45:56 -0400
Received: from web52503.mail.re2.yahoo.com ([206.190.48.186]:33909 "HELO
	web52503.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756124AbXHRQpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 12:45:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=RwXzhxE3j7rj+OeHeukWowXj8+VRsUk8eRkOSWjZ26g4YxrLsiLIwYvvazTT98KuvKZ87R5uHLsMXtLaAc/dN+yPd8hEMiReE/19nHM7t9jxoBk4hOlXJ9X755gXy4AjXgvcYdHKRBBezHrmU53g3oNGlL23s6xCcpeLMUzvTFw=;
X-YMail-OSG: a2c1eVEVM1lTQMz8VJZ0qrmWiY7ku5krc47g6vVLS7EroXn40LpT0zUXI8GI5Fb3N2myUr74gYRnr.5vlCY1xDTRIX3Sa3Nbz886GoJxUdC8NEp9ECVhQM0oUVHuyA--
Date: Sat, 18 Aug 2007 09:45:54 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>
Cc: Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <DDABDE40-EDA1-421A-A3D9-2CE48802A125@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <675612.55480.qm@web52503.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> On Aug 17, 2007, at 15:01:48, Phillip Susi wrote:
> > Valdis.Kletnieks@vt.edu wrote:
> >> It will become even *more* of a "not that common"
> if the lock will  
> >> block moves and ACL changes *across the
> filesystem* for  
> >> potentially *minutes* at a time.
> >
> > It will not take anywhere NEAR minutes at a time
> to update the in  
> > memory dentries, more like 50ms.
> 
> One last comment:
> 
> 50ms to update in-memory dentries would be FRIGGING
> TERRIBLE!!!   
> Using Perl, an interpreted language, the following
> script takes 3.39s  
> to run on one of my lower-end systems:
> 
> for (0 .. 10000) {
> 	mkdir "a-$_";
> 	mkdir "b-$_";
> 	rename "a-$_", "b-$_";
> }
> 
> It's not even deleting things afterwards so it's
> populating a  
> directory with ten thousand entries.  We can easily
> calculate  
> 10,000/3.39 = 2,949 entries per second, or 0.339
> milliseconds per entry.
> 
> When I change it to rmdir things instead, the
> runtime goes down to  
> 2.89s == 3460 entries/sec == 0.289 milliseconds per
> entry.
> 
> If such a scheme even increases the overhead of a
> directory rename by  
> a hundredth of a millisecond on that box it would
> easily be a 2-3%  
> performance hit.  Given that people tend to kill for
> 1% performance  
> boosts, that's not likely to be a good idea.
> 
> Cheers,
> Kyle Moffett
> 
> 

What I suggested was a concept of a new way to look at
a file system. What you are arguing here is why it
wouldn't work based on your theories as to how such a
file system would be implemented. In attacking how
slow you think it might be you are making assumptions
that wouldn't apply to how this would be implemented.
You are assuming that it would be implemented in ways
that you are familiar with. That is a wrong
assumption.

Linux isn't going to make progress when people try to
figure out how to make something NOT work rather than
to make something work. So if you are going to put
effort into this then why not try to figure out how to
get around the issues you are raising rather than to
attack the idea as unsolvable.

When I originally suggested that the names would be a
"hash" I didn't mean that it is going to be only a
hash. You have successfully argued that just a hash
would have problems. Which means that a real solution
is going to be more complex.

I suggest that it would be easier to figure out how to
make moves of large directory structure fast and
effecient with automatic inheritance of rights.

I know it can be done because Microsoft is doing it
and Novell Netware was doing it 20 years ago. So the
fact that it is done by others disproves your
arguments that it can't be done.



Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  
