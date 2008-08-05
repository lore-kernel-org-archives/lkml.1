Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYHEMIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYHEMIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759571AbYHEMFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:05:19 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:46777 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547AbYHEMFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:05:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DGZD56SSMveSzDrCo8LxVsAkXNTBvxRghNqf4oVTRCYDc1cpOg1Wkrw/9InkJHZLp9
         0bR8727BcPfUD5ntvZWAGANnJGMmZgnkQwPhIRQvWrvnkOxUg6y23Qz9fvGe+Yu5e/80
         MLu9bjdBR1s0OzfMvlVezV5tkS7WsqZqac18E=
Message-ID: <e7d8f83e0808050505g4cf7fb4asc36bfa19e130f70d@mail.gmail.com>
Date: Tue, 5 Aug 2008 22:05:12 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: Cliffe <cliffe@ii.net>
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Cc: "Greg KH" <greg@kroah.com>, "Casey Schaufler" <casey@schaufler-ca.com>,
       "Eric Paris" <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4897CFE0.2070008@ii.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <4897BFB4.9090309@schaufler-ca.com> <4897C2A7.7020601@ii.net>
	 <20080805034611.GA11399@kroah.com> <4897CFE0.2070008@ii.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 1:58 PM, Cliffe <cliffe@ii.net> wrote:
> Greg KH wrote:
>>
>> On Tue, Aug 05, 2008 at 11:01:59AM +0800, Cliffe wrote:
>>
>>>
>>> If we had stackable LSMs then the required functionality could simply be
>>> built into the LSM interface. Then the anti-malware would simply stack
>>> itself with other LSMs.
>>>
>>
>> Could it really?  How would such an interface work?
>>
>> Remember, the big issue here isn't the kernel "hooks", but the fact that
>> a lot of people are yet to be convinced that something like this needs
>> to be within the kernel itself.
>>
>> Perhaps we should dig up the proposals for the filesystem-notify type
>> patches, something like that might be all the majority of the virus
>> people need, as they want to just scan things for Windows viruses, not
>> Linux ones, and to do so "lazily" might be sufficient.
>>
>
> From memory Dazuko is a LSM designed for this purpose, although it cannot be
> used on systems running other LSMs due to the lack of stacking support. It
> is used by a bunch of anti-malware programs including ClamAV and AVG.

Sorry to say stacking support really does need to be taken with a grain of salt.

Deeper the stack worse the issue of creating system lag.

Anti-malware stacking into LSM adding there own hooks need to be
looked at as more of a problem than a solution.

Lets take a simple example of Dazuko.   It catches all filesystem
accesses and can alter them.   Side effect all protected documents by
the LSM could end up going threw Dazuko so if a flaw is in the anti
virus that can be exploited straight up complete system exposed.

So really LSM stacking is not the correct solution.   More correct
solution would be list out what features malware and virus scanners
need and extend LSM interfaces so the main LSM could control where the
antivirus/malware scanner was accessing.  Yes there are times you
don't want virus scanners or malware scanners seeing everything.

Containers is another issue around stacking.   Containers being added
to Linux are providing more and more controls.  Currently LSM's are
independent to this.   People have responded that it is light weight
virtualisation so dones not need the need to run a different LSM
secuirty construct inside a container.   Its that it is
virtualistation is why it kinda need to.

Now any stacking design of LSM's have to take into account the needs
of containers.

Of course prefered is no stacking for containers and some form of
cross LSM mapping.  Like prime kernel LSM being selinux,  OS contained
being smack so smack secuirty files coveted to selinux with host OS's
limitations applied so container maintains its secuirty.

Same could be applied to chroot's.   This is a common over site of the
current LSM model.   chroot or containers running different
distrobution inside there is no preformated  way of picking up the
secuirty.   Note could even be the same distrubtion different version
just at one point of time they changed secuirty systems.  So user is
running a chroot or a container to run a old application that is
needed.  But now its running without secuirty.    This is could become
a major issue in time.

So yes needs of stacking have some major headaches.  Its not just a
malware issue.

Peter Dolding
