Return-Path: <linux-kernel-owner+w=401wt.eu-S1763797AbXHNWp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763797AbXHNWp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbXHNWpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:45:10 -0400
Received: from web52501.mail.re2.yahoo.com ([206.190.48.184]:30748 "HELO
	web52501.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753879AbXHNWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:45:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Zd1eNSP0M1kSZ/bC7YN94eBr/zTCHzBHIfMPrySR0oBzR/xTcVX2A6PyeBk4D7I8QSM7W7umlyr9RxBz66uoOCiZ2CEeOY473SKAGtXQWeds3z7OOPuLF17QCUtU1CMVXf4QVuyEhAGfbgo3Dx+7mjZgqX9MLuxBRBKzbi5dG9A=;
X-YMail-OSG: F5TxXGcVM1nnpfFCeWCR6PezT7eEDv.QvNMRUflFMXWLVoS1mBNgz5GU6aH265goM58iqEVyWBh1fEGjhA48198bHDzKIrhBnk9K.Km54Ow5zSWuzQdSLeb7GjI_Zw--
Date: Tue, 14 Aug 2007 15:45:05 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Thinking outside the box on file systems
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <106259.96671.qm@web52501.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I want to throw out some concepts about a new way of
thinking about file systems. But the first thing you
have to do is to forget what you know about file
systems now. This is a discussion about a new view of
looking a file storage that is radically different and
it's more easily undersood if you forget a lot of what
you know. The idea is to create what seems natural to
the user rather than what seems natural to the
programmer.

For example, if a user has not read or write access to
a file then why should they be able to delete the file
- or even list the file in the directory? In order to
grasp this idea the idea of directory permission as
you now know them needs to go away. 

Imagine that the file system is a database that
contains file data, name data, and permission data.
Loose the idea that files have an owner and a group or
the attributes that we are familiar with. Think
instead  that users, groups, managers, application,
and such are objects and there is a complex rights
system that gives access to names that point to file
data.

For example. If you list a directory you only see the
files that you have some rights to and files where you
have no rights are invisible to you. If a file is read
only to you then you can't delete it either. Having
write access to a directory really means that you have
file create rights. You can also delete files that you
have write access to. You would also allocate
permissions to manage file rights like being able to
set the rights of inferior users.

The ACLs that were added to Linux were a step in the
right direction but very incomplete. What should be is
a complex permission system that would allow fine
grained permissions and inherentance masks to control
what permission are granted when someone moves new
files into a directory. Instead of just root and users
there would be mid level roles where users and objects
had management authority over parts of the system and
the roles can be defined in a very flexible way. For
example, rights might change during "business hours".

I want to throw these concepts out there to inspire a
new way of thinging and let Linux evolve into a more
natural kind of file system rather than staying ture
to it's ancient roots. Of course there would be an
emulation layer to keep existing apps happy but I
think that Linux will never be truly what it could be
unless it breaks away from the limitations of the
past.

Anyhow, I'm going to stop at this just to let these
ideas settle in. In my mind there's a lot more detail
but let's see where this goes.

Marc Perkel






Marc Perkel
Junk Email Filter dot com
http://www.junkemailfilter.com


      ____________________________________________________________________________________
Fussy? Opinionated? Impossible to please? Perfect.  Join Yahoo!'s user panel and lay it on us. http://surveylink.yahoo.com/gmrs/yahoo_panel_invite.asp?a=7 

