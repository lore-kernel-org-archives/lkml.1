Return-Path: <linux-kernel-owner+w=401wt.eu-S1031457AbXDJSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031457AbXDJSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031462AbXDJSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:53:51 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:11542 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031457AbXDJSxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:53:49 -0400
Message-ID: <461BDD48.2000904@cfl.rr.com>
Date: Tue, 10 Apr 2007 14:54:00 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, joern@lazybastard.org, tytso@mit.edu
Subject: Re: Add a norecovery option to ext3/4?
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com>
In-Reply-To: <461A760B.1040103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2007 18:54:08.0401 (UTC) FILETIME=[9E973810:01C77BA1]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15108.000
X-TM-AS-Result: No--9.307600-5.000000-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> It means the filesystem should not be writeable when it is mounted.
> This is not the same as saying that the filesystem itself should do no
> IO in the course of making that read-only mount available.

I disagree.

> I respectfully disagree, see above.

Based on what?  I argue that historically the primary use of the read 
only mount flag was to prevent the underlying filesystem from being 
modified and possibly damaged further before it can be fsck'ed.  It 
became common practice to mount the root filesystem read only and run a 
fsck on it, then either reboot or remount read-write depending on if 
fsck had to make changes.

In this context, the meaning of the read only mount flag was clear: do 
not write to the disk.  If you wish to redefine it as "do not allow me 
write access to any files" then you fly in the face of convention, and 
the onus is on you to provide a compelling argument to make such a change.

> In that case you are mounting the same filesystem uner 2 different
> operating systems simultaneously, which is, and always has been, a
> recipe for disaster.  Flagging the fs as "mounted already" would
> probably be a better solution, though it's harder than it sounds at
> first glance.

No, it has not been.  Prior to poorly behaved journal playback, it was 
perfectly safe to mount a filesystem read only even if it was mounted 
read-write by another system ( possibly fsck or defrag ).  You might not 
read the correct data from it, but you would not damage the underlying 
data simply by mounting it read-only.

> Under all conditions it should be safe to mount a read-only block
> device, but that is not the same as mounting a filesystem read-only.

Historically it was the same thing.  I see no reason to change that 
behavior, do you?


