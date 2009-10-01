Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZJAUIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZJAUIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbZJAUIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:08:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:42166 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbZJAUIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E7/lgTehBl99d/Ptgh1iUzp3bFEqfNuwCOWDWFbUsQYmHsDL4Kkm80Nc7SI0Bh6wrS
         +k+LOPcjwF34KYWIb7O2m5wGt4mqcNR7WK57jJIR0PmaDKsX1AIdI5nVzTDzZCxnCoXS
         e08BzJhDbgp5ifEZpU6Jr4k33dTeah9PA/OAs=
MIME-Version: 1.0
In-Reply-To: <56A500B5-DEC5-4B4E-A224-6F5F2D702D2B@suse.de>
References: <20091001145547.GA29152@shell>
	 <7004b08e0910010838i6d0a5f5xeed699be686f6906@mail.gmail.com>
	 <20091001171547.GE29152@shell>
	 <56A500B5-DEC5-4B4E-A224-6F5F2D702D2B@suse.de>
Date: Thu, 1 Oct 2009 15:08:46 -0500
Message-ID: <7004b08e0910011308n5acdee5u9d2853f2ef8f9c15@mail.gmail.com>
Subject: Re: [RFC] Union mounts/writable overlays design
From: kevin granade <kevin.granade@gmail.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Valerie Aurora <vaurora@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 1, 2009 at 12:55 PM, Jan Blunck <jblunck@suse.de> wrote:
> Am 01.10.2009 um 19:15 schrieb Valerie Aurora <vaurora@redhat.com>:
>
>> On Thu, Oct 01, 2009 at 10:38:27AM -0500, kevin granade wrote:


>>>> Non-features
>>>> ------------
>>>>
>>>> Features we do not currently plan to support as part of writable
>>>> overlays:
>>>>
>>>> Online upgrade: E.g., installing software on a file system NFS
>>>> exported to clients while the clients are still up and running.
>>>> Allowing the read-only bottom layer to change while the writable
>>>> overlay file system is mounted invalidates our locking strategy.
>>>>
>>>
>>> So as long as the RO filesystem is NOT mounted as part of an overlay, you
>>> could modify it and then re-construct the previous overlay and things
>>> will
>>> work as expected?
>>> For example could one create a hard drive over CD overlay, then
>>> periodically
>>> (requiring a reboot probably) replace the underlying CD with a new
>>> version
>>> and automagically have new versions of software available?  ( obviously
>>> there are additional complexities in packaging to make this work, but
>>> having
>>> support in the kernel is the first step. )
>>
>> This could theoretically work, but the main problem is resolving
>> differences between files (always the big problem in upgrade).  Say
>> you have /etc/passwd, you add a new user and write to it on the top
>> layer, and then the next upgrade adds a new user to the read-only
>> version.  You're not going to see the new user.
>>
>
> No. Scripts that come with updated packages still need to run on the union.
> Otherwise this is just asking for problems. Probably you could come up with
> a clever merger if the update and the base image is still available.
>

Yes, that sort of thing is what I meant by "additional complexities in
packaging", and I understand that they are in no way trivial, but I
was mostly interested in whether that kind of behavior would be
supported at the kernel level at all.

For example a simpler use, once again with the HD-over-CD distro, is
one could build in an option to "flatten" the entire contents of the
overlay onto a new CD, at which point the CD itself contains the
logical contents of the overlay at that point in time.  The user could
then wipe the HD (or ramdrive in some scenarios) and continue with all
their customizations in place, but no space being used on the RW
filesystem.

Puppy Linux did this in one installation mode by using Unionfs to
progressively "flatten" the user's additions onto successive tracks on
the DVD being used as the RO device.  When the disk ran out of room
the logical "top layer" could be copied to a new disk and the process
restarted.  Obviously this system won't support the iterative addition
of filesystem changes, but it could support more occasional
"flattening" of the overlay onto a new RO media.

Another scenario would be a liveCD that allows the user to make
(potentially extensive) customizations on a ramdrive, then burn a new
liveCD with all the user's customizations included on the disc.

-Kevin Granade
