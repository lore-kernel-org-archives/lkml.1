Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0CID0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:26:50 -0500
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:25956 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932135Ab0CID0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:26:47 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: FKbKtCMVM1kcJojgSvtMzmtUJcjOBZPqoJNj3dK7Iz9myZAAVuP2NseDrMTEbY5FEBehq40rJI1DdvGhTtiE8LdsoWTWVwozbi.IjO2cPx.znPhwrG9eCW58z3ULWiQAGI4F4RPsGuzFn5bhj.4.nYDrL3E.JBiUoBLVizXsgzaFAOSPUUZhTZkRDZC.0OYhfLSAk5yhRj_POHW80KGVMy9g_gzx5Z309kZcVDhxDEMrgIHJQb.bb20I4160dOK5zBp4LDvL7DR_RLDLgNPnEcJzAP4VbyXllXyu5gBGsIxIY77BnDveExdbL.btydvHTL9hbozn7bON7MgfKIRJ
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B95BFF6.5060503@schaufler-ca.com>
Date: Mon, 08 Mar 2010 19:26:46 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Upstream first policy
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> <20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain> <4B9585BD.6070904@redhat.com> <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain> <4B958D7F.1030900@redhat.com> <alpine.LFD.2.00.1003081555480.3669@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003081555480.3669@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 8 Mar 2010, Rik van Riel wrote:
>   
>>> But that thing is _independent_ from the other totally unrelated issue,
>>> namely the fact that "/etc/passwd" is a special name in the namespace. In
>>> other words, there is "content security", but then there is also
>>> "namespace security".
>>>       
>> ... what exactly does the namespace security protect against?
>>
>> What is the threat model that the namespace security protects
>> against, which is not protected by the content based security?
>>     
>
> Umm? Seriously? 
>
> What is _any_ security all about? You try to limit the opportunity for 
> damage, accidental or not.
>
> So let's take a trivial example. Let's say that you are root, and you edit 
> /etc/shadow by hand. I've done it, you've probably done it, it's not 
> rocket science. Now, you do it using any random editor, and most likely 
> it's going to write the new file into a temp-file, and then rename that 
> temp-file over the old file (perhaps creating a backup of the old file 
> depending on editor and settings).
>
> Now, think about what that implies for a moment. Especially consider the 
> case that there were ACL's ("inode-based security") on the old /etc/passwd 
> or /etc/shadow file that got moved away as a backup. What happened to 
> those ACL's when you edited the file using a random editor?
>
> Now, do you see what the difference between pathname-based and inode-based 
> security is? Do you realize how if anybody wants to track accesses to 
> /etc/shadow, they are not going to be interested in the _old_ backup copy 
> of /etc/shadow?
>
> 				Linus
>   

And if you really want to get down to brass tacks it wouldn't hurt
if either camp dusted off their faded copy of the DoD Orange Book
and read a few verses. The access control requirements are stated
in terms of objects but the audit requirements clearly want pathnames.
The security modelers were nuts to protect objects (inodes) but the
accountability fiends insisted on human readable identifiers (pathnames).
The early evaluations (a decade before Linux headed for the Common
Criteria) of Unix systems got bogged down for months at a time while
the needs of objects battled with the needs of accountability.

In the end neither side is right. There are useful things that you
can do with either, but as everyone and his demented gerbil has
pointed out, no one has the True Security Solution. Not even SELinux,
which violates some pretty fundamental security principles
(see: "small enough to be analyzed") in actual deployment. TOMOYO
violates "non-circumventable", just in case anyone thinks I'm
picking on someone. Heck, even Smack isn't perfect, although I will
leave it to others to autoclave that puppy.

Those of you who say we ought to come up with a single framework
that we can use to Do The Right Thing haven't been reading the code.
We have such a framework in the LSM. Sure it's mildly hackish, but
it has only been "open" to new modules for a couple years now, and
security development tends to be slow, with no hardware and blessed
little money behind it. How many file systems went into the VFS
before it got clean enough to talk about in public?

Further, we can polish the filesystem apple until the seeds show
and still never get anywhere near where the modern security issues
reside. Right, networking. Without a security model for that we can
debate how we want our eggs cracked and get just as close to a "real"
solution as we will with the inode/pathname debate.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

