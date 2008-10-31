Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYJaBe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYJaBe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYJaBeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:34:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:47073 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYJaBeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:34:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EBo/B/oBCk9vnZDOJowOAfSXBA/hmRfg2opDlVccRQ8uCn8jGcKv02kwr3d4nD0BuK
         0fAmZTgm7K2b0KhaHXAk4JdO5HUQFvVE7/YunLHuxw6Jb3QwHi1WBbIOLRxwK8TzzR8w
         P4r0lZD4azI3+F3Wi1XxtFveUlCLNDBDT6Gsc=
Message-ID: <3aaafc130810301834w554fbd33p6f423ffef77e92aa@mail.gmail.com>
Date: Thu, 30 Oct 2008 21:34:17 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: merging other repos into linux-2.6
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081030054944.GA19035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081030054944.GA19035@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 1:49 AM, Greg KH <greg@kroah.com> wrote:
> Hi,
>
> In working with some of the current out-of-tree drivers, some of them
> are asking if they could keep their past development history when
> merging the code into the main kernel tree.
>
> Now normally we don't do this for new drivers, just dropping them in in
> one big patch, or sometimes multiple patches to get it through email
> filters.
>
> The comedi group (data acquisition subsystem for Linux) have their whole
> history going back to 2000 in a git tree (well, a cvs->git repo.)

That seems to go back further than Linus's kernel tree goes. Would
this be a problem?

>
> I was wondering if it would be acceptable to graft their tree into the
> linux-2.6 tree (after moving the files to the proper location) to keep
> their whole old history alive.
>
> Now what good that old history would do, I really don't know and can't
> think of a solid reason to need it, other than to give proper authorship
> credit for the various individual drivers and parts of the code (which
> is good to have at tims.)
>
> But the merge looks pretty cool, and it is impressive that git can allow
> this to happen, so there are some extra "style" points a merge like this
> would give :)
>
> So, any thoughts?  Should I graft the trees, or just stick to simple
> "here's the whole driver" type patches like we have been doing?

The Comedi project looks really big, so I can understand wanting to
get the history for it simply because it's a ton of code. But if this
is as hard to do properly as Linus says, I would be wary of the
precedent merging in their history might set. Suddenly we could have
tons of developers clamoring for the same treatment.

If files are being moved and the directory layout of the foreign
repository is nothing like the kernel's layout, could all the old
revisions be formated in one huge patch series against a single
subdirectory? Sure the dates relative to the old work would be totally
wrong, but we would not have to worry about breaking bisections, et
al, while still retaining the content's change history.

That course would depend on how Comedi's repo is laid out and how the
layout will be done to put them in the kernel tree, as well as how
important the difference between 'content creation time' and 'commit
time' are to those involved. If it's just a matter of having
accountability and the ability to look at old versions, perhaps that
difference is not very important. Any way you do this besides the One
Big Patch approach would seem to screw up the history for someone. I
think it would be safer to tinker with the outside project's view of
the past than the kernel's.

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
