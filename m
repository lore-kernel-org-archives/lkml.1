Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXKFOF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXKFOF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXKFOFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:05:48 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:37915 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXKFOFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:05:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=i9gWr8mRXSWsCHKtwp1UqdC+80opHmWMQiNUNS1ewrDx1ipq8ez7TC+U7cW3PTHQ7934s0kEVX5ElW4TAeENvHr5L7J7KHOefFUn5MzK3T3MvrtUz/Z35RJBFMoK9SZqSGcw7Ulm2NxEmWnCYGsFGr6QGt9K8U954HYp+L596Vk=
Date: Tue, 6 Nov 2007 16:05:13 +0200
To: Adrian Bunk <bunk@kernel.org>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106140504.GA6310@ubuntu>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071106063305.GA26163@stusta.de> <C1C917F8-57EA-434C-9FD8-CB5A4EAF2653@mac.com> <20071106085651.GC26163@stusta.de> <20071106113359.GA6041@ubuntu> <20071106114738.GH26163@stusta.de> <1865922a0711060423ue81dbdct413b993e727f6f9@mail.gmail.com> <46B300CD-7A35-4E81-A0AE-EC2BB72016DD@mac.com> <20071106133446.GI26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106133446.GI26163@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 02:34:46PM +0100, Adrian Bunk wrote:
> On Tue, Nov 06, 2007 at 07:49:26AM -0500, Kyle Moffett wrote:
> > On Nov 06, 2007, at 07:23:36, Ahmed S. Darwish wrote:
> >> On 11/6/07, Adrian Bunk <bunk@kernel.org> wrote:
> >>> On Tue, Nov 06, 2007 at 01:34:05PM +0200, Ahmed S. Darwish wrote:
> >>>> As far as I understand the problem now, isspace() accepts the 0xa0 
> >>>> character which might collide with some of UTF-8 encoded characters 
> >>>> cause the high bit is set.
> >>
> >> I admit I'm not experienced in such encoding stuff, but shouldn't the 
> >> ASCII and the ASCII-compatible UTF-8 encodings be enough for the labels?
> >>
> >>> It would not work if someone would e.g. give you UTF-16 encoded strings, 
> >>> but I don't see this happening in practice.
> >>
> >> Won't this complicate the code too much ?
> >
> > Well the VFS (for example) certainly doesn't support any encodings other 
> > than various extended-ASCII forms (which includes UTF-8).  Something like 
> > UTF-16 has extra null characters in-between every normal character, and as 
> > such would fail completely if passed to the VFS.
> 
> Good point.
> 
> > Personally I think that isspace() accepting character 0xA0 is a bug, as 
> > there are several variants of extended ASCII only one of which has that 
> > character as a space.  Others have it as ?? (accented A), etc.
> 
> But even then Smack would still have a similar problem with isgraph().
> 

Great, To summarize the discussion. Will there be a problem in 
accepting ASCII and the UTF-8 ASCII _subset_ _only_ and  return 
-EINVAL for all other cases/ecnodings ?.

i.e. The fragment I sent in a previous message:

/* Filter UTF-8 non-ascii compatible bytes (> 0x7F) */
if (!isascii(c)) return -EINVAL; 
/* Filter unwanted ascii chars */
if (!isspace(c) && !isgraph(c)) return -EINVAL; 

> > In addition 
> > the "canonical" internal text format of the kernel is UTF-8 as that 
> > encoding can represent any character in any other encoding and it is 
> > backwards-compatible with traditional ASCII.
> > 
> > Cheers,
> > Kyle Moffett-
> 
> cu
> Adrian
> 

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
