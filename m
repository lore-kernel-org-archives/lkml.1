Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYHPD6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYHPD6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYHPD5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:57:53 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:13584 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYHPD5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Zp5BOZzE1BD1ljAfPCZPfFaHVRo3umh4Pi0FCy4Nlt2L4XVmYJqy4crHN/FYyQRVLn
         yei6CNxKXgZOeWIXlqzu1T/Wv/DxAOQoJyaPMnglPX2ZFLXekHlppZg1r/rHiyXQ4dk0
         DbtyR/3uoPONYdOVPMexF/ozO47dfSHChbVsM=
Message-ID: <e7d8f83e0808152057h5c607cfbnecdc6f0bd05c5d89@mail.gmail.com>
Date: Sat, 16 Aug 2008 13:57:50 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: david@lang.hm
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Cc: rmeijer@xs4all.nl, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       capibara@xs4all.nl, "Eric Paris" <eparis@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Rik van Riel" <riel@redhat.com>,
       davecb@sun.com, linux-security-module@vger.kernel.org,
       "Adrian Bunk" <bunk@kernel.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, "Pavel Machek" <pavel@suse.cz>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl>
	 <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
	 <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 3:31 AM,  <david@lang.hm> wrote:
> On Fri, 15 Aug 2008, Peter Dolding wrote:
>
>>>> Its called SELinux and SELinux can already do this sort of stuff,
>>>> including things like "only rpm may create files you are permitted to
>>>> execute"
>>>
>>> This "permitted to execute" is what I feel is the wrong aproach with
>>> respect to malware. If you simply allow everything to 'execute', I think
>>> that untrusted programs may still be used for usefull things, but without
>>> the potential do do malice. If you start from the point where everything
>>> both trusted and untrusted  is permitted to be executed, you could make
>>> it
>>> the job of SELinux or any other LSM to make untrusted code run without
>>> doing malice, but with the possibility to still run and do usefull non
>>> malicious  stuff. This might require some aditional hooks in LSM though I
>>> could imagine.
>>>
>>> To take this one step further, it might be usefull to see what kernel/LSM
>>> changes would be needed to allow SELinux and/or possibly better yet,
>>> AppArmor, to work with some powerbox style UI component in order to both
>>> allow and force untrusted programs to run with least authority and still
>>> do usefull stuff.
>>>
>>> I feel the Polaris/Capdesk/Plash approach to untrusted code is much more
>>> prommising than the "don't run" approach used by regular AV products.
>>> Making such an approach integrate with LSM's would IMHO be a much more
>>> fundamental approach to malware.
>>>
>> They way I look at this.   Most users complain that creating profiles
>> for applications is too complex.
>>
>> Lets look for where a system that deals with the same kind of issue.
>> Its in the firewall with ipset http://ipset.netfilter.org/.
>>
>> You have a set of rules to do things assigned in the firewall.   With
>> secuirty this would be the LSM.  User gets to choose from a predefined
>> list for applications without profiles.
>>
>> Lets look at some basics here.  Firefox and most internet applications
>> don't need to edit everything in the user account.   If some link
>> could be designed into LSM for user to once off approve actions
>> outside filesystem permissions from the grouping.  Malware reading and
>> writing stuff would be a lot harder.
>>
>> Major problem everyone keeps on missing.  TALPA is only operating with
>> part of the full information about the file.    When file systems go
>> from native file system to inodes currently the permissions on the
>> native file system are translated to what linux supports and any that
>> don't fit is disregarded.   Due to that difference each file system
>> has its own cache and holes on the file system where viruses could
>> hide data for other OS's on the system.  So TALPA might save Linux
>> only to see another OS on the system infected.   Worst case is if the
>> other OS infected could come back and alter Linux disabling the virus
>> scanner and reinfecting Linux.
>
> please define your threat model. the section above makes no sense with the
> currently defined threat model.
>
> if the linux kernel squashes stuff from a filesystem such that the scanners
> cannot see it then how in the world can linux then server this bad stuff to
> other systems (what the current threat model is defined as)
>
> if you are saying that you want linux to mount filesystems and scan them,
> then unmount them and allow other systems to mount them and be safe, I think
> you alone in this opinion.
>
The threat module you are looking at does not cover all the real world
usage even worse detection of unknown real world threats.

Currently if we have a unknown infection on a  windows partition that
is been shared by linux the scanner on Linux cannot see that the
windows permissions has been screwed with.   OS with badly damaged
permissions is a sign of 1 of three things.   100 percent incompetent
admin, failing harddrive or system is breached.   Now if system is
breached on a partition it is most likely extremely stupid to be
sharing the contents of that partition on a file server until what
breached it has been found and fixed.  Reason until files are cleared
anything on that partition could have a unknown infection that you are
now putting up to server to be spread onto other machines.

You asked how would the Linux Server spread bad stuff to other
systems.   Quite simple be blind miss the warning signs that something
has gone badly wrong in the partition that its getting its files from
and just luck out on a zero day attack with no signature and spread it
around the network leading to more machines in the network having
crippled secuirty.

Blocked from being able to see the real permissions of the file system
takes away one of the means to detect unknowns.   We need every means
of defence we can have.

Remember in a hypervisor environment like http://kvm.sf.net you many
want to scan the OS you are about to run in there before you start it
up.  Particularly if that contained server is going to be serving
files to the network.   You don't want a windows server starting up
that has had its anti-virus defeated spreeding viruses to every other
windows machine in the network.  Particularly if that windows server
is running inside kvm on linux.   Linux is currently not setup for
doing this effectively.  Linux cannot run a Host Intrusion Detection
on the other OS effectively this adds another layer of secuirty to be
breached in a hypervirsor envorment .

Multi OS setups are going to become far more common.  Anti-virus
scanning and threat monitoring needs to move with the times.

Also beware across OS type scanning does have its advantages.  Number
1 a windows virus without the help of wine will not normally infect
linux and vice verser.

Anti-Virus has been for years about chasing the threat.   Lets try to
get in front of it.  You thread model needs a major update its
incomplete.

Peter Dolding
