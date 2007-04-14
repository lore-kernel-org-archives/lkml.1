Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXDNOEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXDNOEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 10:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXDNOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 10:04:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:27020 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574AbXDNOEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 10:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hkp+zjKKL6Ai1QDgwH/0OMW1v9bRLiJ+HFPnCvnYjccY4S2z5lFA5FC2iUsApi5fcq9x+wfjsG1Woj0aaxrXRwGioGL3LOTT+oZ0GzTriXJBCmetIWc6Dk7cFJlBcTJMHdrVz/dG5lofQtqwUQgumhkDoLEqjJLdRJd39x5nMOY=
Message-ID: <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
Date: Sat, 14 Apr 2007 10:04:23 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: ZFS with Linux: An Open Plea
Cc: "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <17952.5537.364603.419364@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <op.tqqwdfzcftfxs2@localhost.localdomain>
	 <17952.5537.364603.419364@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/07, Neil Brown <neilb@suse.de> wrote:
> On Friday April 13, presently42@gmail.com wrote:
> > Before I go on, let me appologise. I don't really know what I hope to
> > accomplish, beyond trying to garner thoughts (and support?) for the topic.
> >
> > Essentially: I want to use Linux and ZFS. I don't particularly care about
> > licences
>
> You may not care about licenses, but a lot of people do.  And they are
> a real issue.
>
> But I'm more interested in what you really want.
> What, specifically, is there in ZFS that you want to use in Linux?
> There is lots of interesting stuff in there, but which bit has caught
> your attention?  It is possible that that functionality can be
> incorporated into Linux without trying to clone or copy ZFS.

ZFS does have some powerful features but much of it depends on their
broken layering of volume management.  Embedding the equivalent of LVM
into a filesystem _feels_ quite wrong.

That aside, the native snapshot capabilities of ZFS really stand out
for me.  The redirect on write semantics aren't exclusive to ZFS;
NetApp's WAFL employs the same.  But with both ZFS and WAFL they were
designed to do snapshots extremely well from the ground up.

Unfortunately in order for Linux to incorporate such a feature I'd
imagine a new filesystem would need to be developed with redirect on
write at its core.  Can't really see ext4 or any other existing Linux
filesystem grafting such a feature into it.  But even though I can't
see it; do others?


Begin non-technical patent related babble:
As you noted licenses are important, as are patents.  Interestingly
I've learned that Sun and NetApp's lawyers had it out over the
redirect on write capability of ZFS.  When the dust settled Sun had
enough patent protection to motivate a truce with NetApp.

The interesting side-effect is now ZFS is "open" and with that comes
redirect on write in a file system other than WAFL.  But ZFS's CDDL
conflicts with the GPL so I'm not too sure how Linux could hit the
ground running in this potentially patent mired area of filesystem
development.  The validity of NetApp having patented redirect on write
aside; does the conflict between CDDL and GPL _really_ matter?  Or did
the CDDL release of ZFS somehow undermine NetApp's WAFL patent?

Mike
