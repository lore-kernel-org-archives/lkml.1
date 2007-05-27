Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXE0QMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXE0QMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbXE0QMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 12:12:21 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:35968 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755367AbXE0QMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 12:12:19 -0400
X-YMail-OSG: qyyjeGkVM1kon3xDayTM00qqaVJQrT3JL4XYDoU50oUfeFJt2RCS.pcFAu8GWwNd97xrHp.l2g--
X-RocketYMMF: rancidfat
Date: Sun, 27 May 2007 09:12:18 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
To: Cliffe <cliffe@iinet.net.au>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <46594282.8010307@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <653438.15244.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Cliffe <cliffe@iinet.net.au> wrote:

>  >> On the other hand, if you actually want to protect the _data_, then 
> tagging the _name_ is flawed; tag the *DATA* instead.
> 
> Would it make sense to label the data (resource) with a list of paths 
> (names) that can be used to access it?

Program Access Lists (PALs) were* a feature of UNICOS. PALs could
contain not only the list of programs that could use them, but what
attributes the processes required as well. Further, you could
restrict or raise privilege based on the uid, gid, MAC label, and
privilege state of the process during exec based on the PAL. 

> Therefore the data would be protected against being accessed via 
> alternative arbitrary names. This may be a simple label to maintain and 
> (possibly to) enforce, allowing path based confinement to protect a 
> resource. This may allow for the benefits of pathname based confinement 
> while avoiding some of its problems.

Yep, but you still have the label based system issues, the classic
case being the text editor that uses "creat new", "unlink old",
"rename new to old". When the labeling scheme is more sopisticated
than "object gets label of subject" label management becomes a major
issue.

> Obviously this would not protect against a pathname pointing to 
> arbitrary data…

Protecting special data is easy. Protecting arbitrary data is the
problem.

> Just a thought.

Not a bad one, and it would be an easy and fun LSM to create.
If I were teaching a Linux kernel programming course I would
consider it for a class project.

-----
* I have used the past tense here in spite of the many
  instances of UNICOS still in operation. I don't believe
  that there is any current development on UNICOS.


Casey Schaufler
casey@schaufler-ca.com
