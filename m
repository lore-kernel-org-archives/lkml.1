Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbXJTLFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbXJTLFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbXJTLFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:05:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48536 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbXJTLFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:05:10 -0400
Date: Sat, 20 Oct 2007 13:05:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
In-Reply-To: <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com>
 <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org>
 <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 19 2007 13:40, Linus Torvalds wrote:
>On Fri, 19 Oct 2007, Andreas Gruenbacher wrote:
>> 
>> Non-trivial modules (i.e., practically everything beyond capabilities) become 
>> effective only after loading policy, anyway. If you can load policy, you can 
>> as well first load a security module without making the system insecure.
>
>I'd like to note that I asked people who were actually affected, and had 
>examples of their real-world use to step forward and explain their use, 
>and that I explicitly mentioned that this is something we can easily 
>re-visit.
>

I do have a pseudo LSM called "multiadm" at 
http://freshmeat.net/p/multiadm/ , quoting:

	The MultiAdmin security framework kernel module provides a means 
	to have multiple "root" users with unique UIDs. This bypasses 
	collation order problems with NSCD, allows you to have files 
	with unique owners, and allows you to track the quota usage for 
	every "real" user. It also implements a "sub-admin", a partially 
	restricted root user who has full read-only access to most 
	subsystems, but write rights only to a limited subset, for 
	example writing to files or killing processes only of certain 
	users.

The use case is so that profs (taking the role of sub-admins), can 
operate on student's data/processes/etc. (quite often needed), but 
without having the full root privileges.

Policy is dead simple since it is based on UIDs. The UID ranges can be 
set on module load time or during runtime (sysfs params). This LSM is 
basically grants extra rights unlike most other LSMs[1], which is why 
modprobe makes much more sense here. (It also does not have to do any 
security labelling that would require it to be loaded at boot time 
already.)

Does that sound productive?


>The fact is, security people *are* insane. You just argue all the time, 
>instead fo doing anything productive. So please don't include me in the Cc 
>on your insane arguments - instead do something productive and I'm 
>interested.

[1] SELinux: What I remember from coker.com.au's selinux test machine, 
everyone had UID 0 and instead had powers revoked.
