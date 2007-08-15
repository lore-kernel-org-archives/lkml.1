Return-Path: <linux-kernel-owner+w=401wt.eu-S936948AbXHOWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936948AbXHOWkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760390AbXHOWkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:40:20 -0400
Received: from web52509.mail.re2.yahoo.com ([206.190.48.192]:28398 "HELO
	web52509.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760378AbXHOWkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:40:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nUog/w4h6WNbN21SMhleAiKRdUBvi0ZQsZymvsDQh9z5DN23urjHxJ0XKV3DdC9rYwxupQFlXcr2UfFeIs3IbN+m+9TB549uSV91B9DEVS7od2fvWxjWwW/v2j3j6lP6Z/k9PKiIeITWrqgrZhVPsaSiVUUKtY1itRDWTR2ZolA=;
X-YMail-OSG: pcUd35UVM1kB0Njo3_WwpV42j.7uZIaA2pRyr2E7bW_q2mjlIOn9tMNX8tegqRhFnD.QvoTbknPzXODLeDAn6f6Nr3U21KcJxZ0fsK3FMuGgO0Ms7lMMMADYCtxC6tBLsl46Tu72uHqjqOWtkAYFx2lo
Date: Wed, 15 Aug 2007 15:40:16 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Thinking outside the box on file systems
To: Kyle Moffett <mrmacman_g4@mac.com>, Phillip Susi <psusi@cfl.rr.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <15991.37821.qm@web52509.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> Al Viro added to the CC, since he's one of the
> experts on this stuff  
> and will probably whack me with a LART for
> explaining it all wrong,  
> or something. :-D
> 

Thanks - I appreciate that.

Just to catch everyone up on what this thread is
about, I'm proposing a new way of looking at file
systems where files no longer have permission, owners,
or groups, or file attributes. The idea is that
people, groups, managers, applications, and other
objects have permissions to names that are pointers to
files.

> On Aug 15, 2007, at 16:38:36, Phillip Susi wrote:
> > Kyle Moffett wrote:
> >> We've *always* had to do this; that's what "chmod
> -R" or "setfacl - 
> >> R" are for :-D.  The major problem is that the
> locking and lookup  
> >> overhead gets really significant if you have to
> look at the entire  
> >> directory tree in order to determine the
> permissions for one  
> >> single object.  I definitely agree that we need
> better GUIs for  
> >> managing file permissions, but I don't see how
> you could modify  
> >> the kernel in this case to do what you want.
> >
> > I am well aware of that, I'm simply saying that
> sucks.  Doing a  
> > recursive chmod or setfacl on a large directory
> tree is slow as all  
> > hell.
> 
> Doing it in the kernel won't make it any faster.
> 
> 
> > As for hard links, your access would depend on
> which name you use  
> > to access the file.  The file itself may still
> have an acl that  
> > grants or denies access to people no matter what
> name they use, but  
> > if it allows inheritance, then which name you
> access it by will  
> > modify the effective acl that it gets.
> 
> You can't safely preserve POSIX semantics that way. 
> For example,  
> even without *ANY* ability to read /etc/shadow, I
> can easily "ln /etc/ 
> shadow /tmp/shadow", assuming they are on the same
> filesystem.  If  
> the /etc/shadow permissions depend on inherited ACLs
> to enforce  
> access then that one little command just made your
> shadow file world- 
> readable/writeable.  Oops.
> 
> Think about it this way:
> Permissions depend on *what* something is, not
> *where* it is.  Under  
> Linux you can leave the digital equivalent of a
> $10,000 piece of  
> jewelry lying around in /var/www and not have to
> worry about it being  
> compromised as long as you set your permissions
> properly (not that I  
> recommend it).  Moving the piece of jewelry around
> your house does  
> not change what it *is* (and by extension does not
> change the  
> protection required on it), any more than "ln
> /etc/shadow /tmp/ 
> shadow" (or "mv") changes what *it* is.  If your
> /house is really  
> extraordinarily secure then you could leave the
> jewelry lying around  
> as /house/gems.bin with permissions 0777, but if
> somebody had a back- 
> door to /house (an open fd, a careless typo, etc)
> then you'd have the  
> same issues.

My proposal is the same somewhat. If one put
restricting on a specific name to deny access to users
then that denial follows that filename even if it is
copied or moved. However if a file has no specific
restrictions and is in a restricted directory then the
file inherits the restrictions and permissions of the
new directory based on where it is.

If you don't want your jewlery laying around then
don't put a copy of it in a folder where users have
access to it.




Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


       
____________________________________________________________________________________
Yahoo! oneSearch: Finally, mobile search 
that gives answers, not web links. 
http://mobile.yahoo.com/mobileweb/onesearch?refer=1ONXIC
