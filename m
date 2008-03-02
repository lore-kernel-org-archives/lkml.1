Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbYCBVka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbYCBVka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYCBVkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:40:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:1488 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbYCBVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nq7yoqirsQQwRWjaKypZSG+P7tV7zZklqjIqUs2/+QdVPM/6jAua8La7kN6S55gjZoLuYWMnhSHRPq/86Q7bAu/v+7DVSxqtEc8+mjZKbUSBoXHiErfVf9HFuHXSIArVtLvAzYtWTl8yWLca4//CU6KoVKy9sRTz9j3q8BBWdoo=
Message-ID: <46a038f90803021340uf1c9c6te5501d9fb0565f19@mail.gmail.com>
Date: Mon, 3 Mar 2008 10:40:15 +1300
From: "Martin Langhoff" <martin.langhoff@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: kernel.org git tree corrupt?
Cc: "Steve French" <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       git@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0803021302070.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650803020749o469f2e48l125a55267b0b5d13@mail.gmail.com>
	 <alpine.LFD.1.00.0803021302070.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 10:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  In that case, your "origin" simply isn't updated, but points somewhere
>  long back in history. I can only assume that cogito has done something
>  wrong, like not been able to handle packed refs or something, and you have
>  an updated tree but "origin" pointing to way back in the history.

Strange - cogito over git protocol will use git itself to peek at the
references. Steve, what is your git version?

>  > Ideas for another solution short of recloning and sorting through all
>  > of the last month or two of patches that affect this directory by
>  > hand?

Linus' plan assumes you have a .git/config file. I don't think a
cogito-based checkout follows such modern conventions - here's an
alternative plan:

 - make sure you have a current git

 - get a fresh clone of linux-2.6, and in there

    # tell it about your old checkout
    $ git remote add oldlinux /path/to/your/older/linux/checkout/.git
    $ git fetch oldlinux
    # visualise what's in there
    $ gitk origin/master oldlinux/master

    # you may want to merge your old branch
    $ git merge oldlinux/master

hth,


martin
