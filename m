Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0BVAaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 19:30:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:59082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab0BVAae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 19:30:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=GL9dUtBbPS9w5+FH9xWwQ5HBMVrCpbEEY3o5kHdr0PJm1XmUvo/PuUlmCVY6qum80H
         lItKISSYJiW+sU2wrrz5pixTFWUgzayBTnkwYTnxJzEFoTL4dlDhEXdF48+YAN089OEN
         n7c8E8yJWy1wg19Adw5+mahegmcV0vD7ojvkU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: Commit 085219f79cad broke Sparc-32 back in 2.6.28.
Date: Mon, 22 Feb 2010 01:28:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: rob@landley.net, qemu-devel@nongnu.org, blauwirbel@gmail.com,
       pbonzini@redhat.com, atar4qemu@googlemail.com,
       linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <f43fc5581002201359x50aff2b1ofc4f816762bda597@mail.gmail.com> <201002211025.11588.rob@landley.net> <20100221.155719.226789440.davem@davemloft.net>
In-Reply-To: <20100221.155719.226789440.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <201002220128.21067.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 February 2010 12:57:19 am David Miller wrote:
> From: Rob Landley <rob@landley.net>
> Date: Sun, 21 Feb 2010 10:25:09 -0600
> 
> > 085219f79cad89291699bd2bfb21c9fdabafe65f is first bad commit
> > commit 085219f79cad89291699bd2bfb21c9fdabafe65f
> > Author: Sam Ravnborg <sam@ravnborg.org>
> > Date:   Fri Jan 2 18:47:34 2009 -0800
> > 
> >     sparc32: use proper types in struct stat
> >     
> >     Like sparc64 use proper types in struct stat
> >     
> >     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> >     Signed-off-by: David S. Miller <davem@davemloft.net>
> > 
> > This commit breaks stat and makes sparc32 essentially unusable.  It changes 
> > the size of the various types in stat.h, and means that if you "mount -t tmpfs 
> > /tmp /tmp" and then try to ls /tmp, ls dies with a memory allocation error.
> > 
> > I've confirmed that reverting it fixes the problem.
> 
> Thanks for tracking this down Rob, I'll work on a fix and
> push it around.

Looking at how whole sparc32 has been apparently broken for over a year now
because of a purely cleanup patch I wonder if it would be appropriate to
make sparc32 into 'legacy only' and provide 'a stability promise' for it?

Just an idea.. ;)

--
Bartlomiej Zolnierkiewicz
