Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbYHON2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbYHON2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbYHON1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:27:32 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:45844 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbYHON13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:27:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SmYKJjo6Ds9gdS0jbQBujrdb9/v7ct1VM4+E4nIG+FW9p6NCT811r9WWpDJ8SSdcrP
         kSmWg5XVSo0hV/aJNMJXHMsgOYR2xKycsKdJs1VT0e/cZ+1oB/zyEYY6VQ+h3st0kLgZ
         63ax+yVp5Yeu39E0wWkNJhNK5lw4Har4zUqQc=
Message-ID: <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
Date: Fri, 15 Aug 2008 23:27:27 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: rmeijer@xs4all.nl
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl, david@lang.hm,
       "Eric Paris" <eparis@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Rik van Riel" <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 10:22 PM, Rob Meijer <capibara@xs4all.nl> wrote:
> On Fri, August 15, 2008 13:02, Alan Cox wrote:
>>> The package manager approach is interesting in that it marks 'trusted',
>>> and is thus permissive rather than restrictive. Maybe it would be
>>> possible
>>> to extend on this and simply define a set of currently unprivileged
>>> access
>>> as privileged for untrusted applications. That way you could allow
>>> untrusted software to run without risk, even if that untrusted software
>>> turns out to be malware. That is, it may be possible to solve the
>>> malware
>>> problem in a much more fundamental way here by just allowing malware to
>>> run without the need to know if it is malware, just by running untrusted
>>> software with reduced privileges.
>>>
>>
>> Its called SELinux and SELinux can already do this sort of stuff,
>> including things like "only rpm may create files you are permitted to
>> execute"
>
> This "permitted to execute" is what I feel is the wrong aproach with
> respect to malware. If you simply allow everything to 'execute', I think
> that untrusted programs may still be used for usefull things, but without
> the potential do do malice. If you start from the point where everything
> both trusted and untrusted  is permitted to be executed, you could make it
> the job of SELinux or any other LSM to make untrusted code run without
> doing malice, but with the possibility to still run and do usefull non
> malicious  stuff. This might require some aditional hooks in LSM though I
> could imagine.
>
> To take this one step further, it might be usefull to see what kernel/LSM
> changes would be needed to allow SELinux and/or possibly better yet,
> AppArmor, to work with some powerbox style UI component in order to both
> allow and force untrusted programs to run with least authority and still
> do usefull stuff.
>
> I feel the Polaris/Capdesk/Plash approach to untrusted code is much more
> prommising than the "don't run" approach used by regular AV products.
> Making such an approach integrate with LSM's would IMHO be a much more
> fundamental approach to malware.
>
They way I look at this.   Most users complain that creating profiles
for applications is too complex.

Lets look for where a system that deals with the same kind of issue.
Its in the firewall with ipset http://ipset.netfilter.org/.

You have a set of rules to do things assigned in the firewall.   With
secuirty this would be the LSM.  User gets to choose from a predefined
list for applications without profiles.

Lets look at some basics here.  Firefox and most internet applications
don't need to edit everything in the user account.   If some link
could be designed into LSM for user to once off approve actions
outside filesystem permissions from the grouping.  Malware reading and
writing stuff would be a lot harder.

Major problem everyone keeps on missing.  TALPA is only operating with
part of the full information about the file.    When file systems go
from native file system to inodes currently the permissions on the
native file system are translated to what linux supports and any that
don't fit is disregarded.   Due to that difference each file system
has its own cache and holes on the file system where viruses could
hide data for other OS's on the system.  So TALPA might save Linux
only to see another OS on the system infected.   Worst case is if the
other OS infected could come back and alter Linux disabling the virus
scanner and reinfecting Linux.

TALPA from its current location is partly blind same with most other
anti-virus and malware scanner running on linux.   Unfortunately to
remove this blindness is rework the file system interface layer.
Single cache for all file system drivers with TALPA embeded where it
can scan everything about a file so when its clean its truly clean.
Also for desktop users being able to see the permissions on there
removable media to make sure they are correct would be a god send.

This is a flaw that people from most other OS's would not think about.
  Since Linux is one of the rare places it exists. LIM and HIDS are
also effected by this blindness.   A hids scanning file systems under
Linux can report that everything is fine when the damage is
permissions that Linux is not translating.  We have a black hole of
thrown away data that cannot be simply scanned.

Long term performance also comes into play.   Current system we have a
few too many caches to ever think about making the file system cache
lock less.   Its blinding and a future bottle neck.

Suppose this defect has been there so long people are thinking of it as normal.

Peter Dolding
