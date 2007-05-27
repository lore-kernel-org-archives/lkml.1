Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbXE0HZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbXE0HZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 03:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbXE0HZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 03:25:29 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:55482 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXE0HZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 03:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q+z/HOnoC+u4AKPYpI/KfFfWeK3o7g2fb9MyPAscgj43wCxy9AKvhpk7ncc9BMV+3NuLRdmihAc/gS620XSporhKdMFv0xRW+9E3rRj2MnpZ4tyvW5IW3FImyZFRWs5FEkjyJIA3IXoyc90ZH5fAxBa91DDihqboH7QFMWfN8hQ=
Message-ID: <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com>
Date: Sun, 27 May 2007 16:25:27 +0900
From: "Toshiharu Harada" <haradats@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Cc: "James Morris" <jmorris@namei.org>, casey@schaufler-ca.com,
       "Andreas Gruenbacher" <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <309300.41401.qm@web36615.mail.mud.yahoo.com>
	 <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com>
	 <Line.LNX.4.64.0705261442000.23020@d.namei>
	 <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
	 <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/27, Kyle Moffett <mrmacman_g4@mac.com>:
> On May 26, 2007, at 19:08:56, Toshiharu Harada wrote:
> > 2007/5/27, James Morris <jmorris@namei.org>:
> >> On Sat, 26 May 2007, Kyle Moffett wrote:
> >>> AppArmor).  On the other hand, if you actually want to protect
> >>> the _data_, then tagging the _name_ is flawed; tag the *DATA*
> >>> instead.
> >>
> >> Bingo.
> >>
> >> (This is how traditional Unix DAC has always functioned, and is
> >> what SELinux does: object labeling).
> >
> > Object labeling (or labeled security) looks simple and straight
> > forward way, but it's not.
> >
> > (1) Object labeling has a assumption that labels are always
> > properly defined and maintained. This can not be easily achieved.
>
> That's a circular argument, and a fairly trivial one at that.

Sorry Kyle, I don't think it's a trivial one.  The opposite.

> If you can't properly manage your labels, then how do you expect any
> security at all?

Please read my message again. I didn't say, "This can never be achieved".
I said, "This can not be easily achieved".

>  If you can't manage your "labels", then pathname-
> based security won't work either.  This is analogous to saying
> "Pathname-based security has an assumption that path-permissions are
> always properly defined and maintained", which is equally obvious.

Yes,! You got the point.
Both label-based and pathname-based apporaches have the advantaes and
difficluties.
In that sense they are equal. That's what I wanted to say.
Both approaches can be improved and even can be used combined to
overcome the difficulties. Let's not fight against and think together,
then we can make Linux better.

> If you can't achieve the first with reasonable security, then you
> probably can't achieve the second either.  Also, if you can't manage
> correct object labeling then I'm very interested in how you are
> maintaining secure Linux systems without standard DAC.

I'm very interested in how you can know that you have the
correct object labeling (this is my point). Could you tell?
I assume your best efforts end up with
- have a proper fc definitions and guard them (this can be done)
- executes relabeling as needed (best efforts)
- hope everything work fine

> > (2) Also, assigning a label is something like inventing and
> > assigning a *new* name (label name) to objects which can cause flaws.
>
> I don't understand how assigning new attributes to objects "can cause
> flaws", nor what flaws those might be; could you elaborate further?
> In particular, I don't see how this is really all that more
> complicated than defining additional access control in
> apache .htaccess files.  The principle is the same:  by stacking
> multiple independent security-verification mechanisms (Classical UNIX
> DAC and Apache permissions) you can increase security, albeit at an
> increased management cost.  You might also note that ".htaccess"
> files are yet another form of successful "label-based" security; the
> security context for a directory depends on the .htaccess "label"
> file found within.  The *exact* same principles apply to SELinux: you
> add additional attributes backed by a simple and powerful state-
> machine.  The cross-checks are lower-level than those from .htaccess
> files, but the principles are the same.

I don't deny DAC at all.  If we deny DAC, we can't live with Linux
it's the base.  MAC can be used to cover the shortages of DAC and
Linux's simple user model, that's it.

>From security point of view, simplicity is always the virtue and the way to go.
Inode combined label is guaranteed to be a single at any point time.
This is the most noticeable advantage of label-based security.
But writing policy with labels are somewhat indirect way (I mean, we need
"ls -Z" or "ps -Z").  Indirect way can cause flaw so we need a lot of work
that is  what I wanted to tell.

Cheers,
Toshiharu Harada
haradats@gmail.com
