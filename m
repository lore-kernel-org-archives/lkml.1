Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXJ3Xij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXJ3Xij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbXJ3Xia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:38:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:58797 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJ3Xi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Fk57ZsM2VorFBMxyWjJNhe0KhxyzAEJRlWEjjILIkCkcKcyhJCO7mgAWpPiuY/+DHJyFllDTGqriW9Ldub2uCoQJnYA3J8f2Hjl9fJuw1/x7BeQgTkzezx2psGZo8TV0eoo9HcuM1f5hSq2uIE25rDQ6xNKPV5uy7eZnQg4wAkA=
Message-ID: <4727C06A.4060005@gmail.com>
Date: Wed, 31 Oct 2007 09:38:18 +1000
From: Peter Dolding <oiaohm@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>  <4726377A.4080807@crispincowan.com> <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com> <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> I disagree.
>
> Traditionally, Linux has given a process all capabilities when the
> UID changed to 0 (either by setuid(2) or executing a SUID binary).
> This has been relieved over the years, and right now with LSMs in the
> field, it is possible to 'deactivate' this special case for UID 0.
>   
> SELinux does not have this special case for UID 0. Neither does it
> seem to use capabilities (quick grep through the source). So
> basically, all users are the same, and no one has capabilities by
> default. Does SELinux thus break with other LSMs?
>
> Now assume a SELinux system where all users have all capabilities
> (and the policy that is in place restricts the use of these
> capabilities then) -- should not be that unlikely. Does that break
> with other LSMs?
>   
MultiAdmin loaded before Selinux breaks Selinux since Multi Admin rules 
are applied over using Selinux rules.  This is just the way it is 
stacking LSM's is Just not healthy you always risk on LSM breaking 
another.  Part of the reason why I have suggested a complete redesign of 
LSM.  To get away from this problem of stacking.

I see MultiAdmin purely in the class of posix file capabilities( Fine 
grained replacement to SUID).
This is a standard feature fix not part of LSM.  Note it can not replace 
all SUID bits due to some internals of applications design need to be 
changed to support posix file capabilities in particular not checking if 
running as UID 0.  Traditional  UID 0 is already optional for 
applications without  LSM's.

Posix file capabilities only applies to applications only.  MultiAdmin 
being the user mirror of Posix file capabilities.

MultiAdmin patch to the user side may allow more SUID bits to be killed 
off from the start line.  So increasing overall system security.

Of course MultiAdmin might end up two halfs.   One a standard feature 
that hands out capabilities to users that LSMs can overrule.  And one a 
user by user directory access control LSM directory control LSM less 
likely to cause problems.

I really don't see the need for a LSM stacking order.  Some features 
just should not be LSM's in my eyes.  MultiAdmin is one of them.

Traditional way has all ready been expanded for applications without 
LSM's.  So my call still stand O heck head ache rating.   Because its in 
the wrong place.  Particularly when you think people will want to use it 
stacked with other LSM's.   Stacking should be avoided where able.   
This means at least some of Multiadmin features just have to be done 
core kernel as a normal kernel module to avoid stacking and breaking the 
LSM.

Note posix file capabilities was developed as a LSM module too at first 
the point came where it was going to cause more trouble for other LSMs 
granting stuff in conflict.    Both Multiadmin and posix file 
capabilities share a lot in common.  Both developed in the wrong place.  
Both required to be else where.  Even there function is similar breaking 
down root powers and handing them out more effectively.  So in my eyes 
it is a pure Posix extension not a LSM.

Peter Dolding
