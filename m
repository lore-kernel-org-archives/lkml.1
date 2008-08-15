Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbYHORdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbYHORdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 13:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYHORco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 13:32:44 -0400
Received: from mail.lang.hm ([64.81.33.126]:41611 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbYHORcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 13:32:43 -0400
Date: Fri, 15 Aug 2008 10:31:33 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Dolding <oiaohm@gmail.com>
cc: rmeijer@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>, capibara@xs4all.nl,
       Eric Paris <eparis@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Rik van Riel <riel@redhat.com>, davecb@sun.com,
       linux-security-module@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, Pavel Machek <pavel@suse.cz>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
In-Reply-To: <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808151024120.15109@asgard.lang.hm>
References: <18129.82.95.100.23.1218802937.squirrel@webmail.xs4all.nl> <e7d8f83e0808150627m7a5c8738n8ac42d77c45eea76@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008, Peter Dolding wrote:

>>> Its called SELinux and SELinux can already do this sort of stuff,
>>> including things like "only rpm may create files you are permitted to
>>> execute"
>>
>> This "permitted to execute" is what I feel is the wrong aproach with
>> respect to malware. If you simply allow everything to 'execute', I think
>> that untrusted programs may still be used for usefull things, but without
>> the potential do do malice. If you start from the point where everything
>> both trusted and untrusted  is permitted to be executed, you could make it
>> the job of SELinux or any other LSM to make untrusted code run without
>> doing malice, but with the possibility to still run and do usefull non
>> malicious  stuff. This might require some aditional hooks in LSM though I
>> could imagine.
>>
>> To take this one step further, it might be usefull to see what kernel/LSM
>> changes would be needed to allow SELinux and/or possibly better yet,
>> AppArmor, to work with some powerbox style UI component in order to both
>> allow and force untrusted programs to run with least authority and still
>> do usefull stuff.
>>
>> I feel the Polaris/Capdesk/Plash approach to untrusted code is much more
>> prommising than the "don't run" approach used by regular AV products.
>> Making such an approach integrate with LSM's would IMHO be a much more
>> fundamental approach to malware.
>>
> They way I look at this.   Most users complain that creating profiles
> for applications is too complex.
>
> Lets look for where a system that deals with the same kind of issue.
> Its in the firewall with ipset http://ipset.netfilter.org/.
>
> You have a set of rules to do things assigned in the firewall.   With
> secuirty this would be the LSM.  User gets to choose from a predefined
> list for applications without profiles.
>
> Lets look at some basics here.  Firefox and most internet applications
> don't need to edit everything in the user account.   If some link
> could be designed into LSM for user to once off approve actions
> outside filesystem permissions from the grouping.  Malware reading and
> writing stuff would be a lot harder.
>
> Major problem everyone keeps on missing.  TALPA is only operating with
> part of the full information about the file.    When file systems go
> from native file system to inodes currently the permissions on the
> native file system are translated to what linux supports and any that
> don't fit is disregarded.   Due to that difference each file system
> has its own cache and holes on the file system where viruses could
> hide data for other OS's on the system.  So TALPA might save Linux
> only to see another OS on the system infected.   Worst case is if the
> other OS infected could come back and alter Linux disabling the virus
> scanner and reinfecting Linux.

please define your threat model. the section above makes no sense with the 
currently defined threat model.

if the linux kernel squashes stuff from a filesystem such that the 
scanners cannot see it then how in the world can linux then server this 
bad stuff to other systems (what the current threat model is defined as)

if you are saying that you want linux to mount filesystems and scan them, 
then unmount them and allow other systems to mount them and be safe, I 
think you alone in this opinion.

David Lang
