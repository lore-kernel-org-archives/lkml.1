Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYHFOLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYHFOLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYHFOLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:11:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:7362 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbYHFOLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GvJm8aMy8HOAfFl638kxvhISd7fvx1mFo1asPxl/RoQdeAdhuUNFiFeGCY5Mn2sPau
         drGjQT2BJhBhbjTh8slMpzmFlpHGnxd+U0Xsk7x5apAP+5/yiQA4v5EQ3XMEqvDHZQxH
         ZDKStI19uNq/HlElvIsppwxMDv5hFf0KecCxU=
Message-ID: <e7d8f83e0808060711o43f1dc9frc859c2583e51b195@mail.gmail.com>
Date: Thu, 7 Aug 2008 00:11:35 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Eric Paris" <eparis@redhat.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       "Rik van Riel" <riel@redhat.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <1218030956.27684.232.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805181141.GA10700@kroah.com>
	 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805205129.37d873f0@bree.surriel.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
	 <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
	 <20080806064944.441305eb@infradead.org>
	 <1218030956.27684.232.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 11:55 PM, Eric Paris <eparis@redhat.com> wrote:
> On Wed, 2008-08-06 at 06:49 -0700, Arjan van de Ven wrote:
>> On Wed, 6 Aug 2008 09:11:14 -0400
>> > There was probably an implicit assumption on everyone's part,
>> > including Red Hat's, that what ought to be done was to replace the
>> > existing syscall-based event trapping with some other interface that
>> > more or less does the same thing in a cleaner way -- NOT to have all
>> > of the AV and other product vendors go out and completely rethink
>> > their models.  And that's not because we inherently object to
>> > rethinking.  It's really an issue of what kind of time frame we have
>> > before a new OS goes out that completely breaks our products.
>>
>> not writing to the syscall table hasn't been possible/allowed for..
>> about 5 years now. (yes I know there were still bad hacks possible
>> until 2 years ago). So I'm sorry, but the timeline argument doesn't
>> hold, you've had 5+ years of warning.
>>
>> All existing RHEL products already don't allow this (I know it for the
>> earlier ones since I was part of the design team)...  unless your
>> software acts entirely like a rootkit (but even then)
>
> Other options involved overwriting LSM function pointers.  I was told
> that recently moving SELinux to be statically compiled in apparently
> messed them up on that method, at least for RH products.  The other
> method I've heard is hunting down all of the filesystem_operations
> structs and overwriting those functions.  I was also told that until
> recently pages marked RO could just be marked RW and then remarked RO,
> although it was recently fixed to RO pages stayed RO.  So yeah, I'd have
> to call them all ugly rootkit like hacks.
>
> they just keep finding uglier and uglier ways to infiltrate the kernel
> which is why I was ask to try to help get a clean solution.
>
Simplely they are following the windows way of doing things.  Rootkit
the OS no one will stop us.  Sorry that RootKitting is not going to
work here long term because we will fix Root Kit weaknesses.  TPM from
IBM will make it even harder.  Nice bits of that are in 2.6.27.

Allowing LSM stacking solves nothing.   IBM's developers credentials
is a far better place for file system monitoring to hook in.  Its pre
caching allows all the alterations they could want.  Even better
credentials is a required patch to clean up Linux internal permission
splating all over the place.  Then generic filesystem caching sits on
top of that.   So 1 less cache needed.  Ie the cache of passes and
failures they keep so they don't slow the system down too much.

About time they wake up Linux Different OS.  We have zero tolerance of
root kits.   There is a section with the design to provide the file
system monitoring and the network monitoring both without being in LSM
space.  So why do they need LSM's.   Cannot they just use system LSM's
to protect there anti-virus like everyone else.   No need to treat
them special.   If they have a issue with a LSM not being good enough
they need to speak up.

They really need to provide what they want to do to us.   There issue
is they keep on looking in the wrong places and doing things the
windows way.   This is not WINDOWS.   In time mac and other OS's could
come tighter on root kits as well causing the programs to fail as
well.   Basically get use to working with a OS that does not tolerate
secuirty flaws.

Peter Dolding
