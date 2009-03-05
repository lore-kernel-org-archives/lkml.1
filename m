Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbZCEJAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbZCEJAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZCEJAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:00:35 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:55692 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCEJAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:00:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hSlkDJJojYJ4QLXAdk1BVV3aWvy5a6MpzdCCzvSFXkbK6lDBrffWqekQ3IHtnckUh/
         3hc2SEXYvVeIHZ4393h8FsQmvyfWM0RfR3Xn4QU1hz7bYMiiS797qbuy1iN9ZNuPlLFq
         6YmG7iKSCZbVUd/RUJmc8WpBvBPvitrm9YJuQ=
Date: Thu, 5 Mar 2009 10:00:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid
	C library confusion.
Message-ID: <20090305090027.GD5359@nowhere>
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com> <20090305060436.GA5359@nowhere> <dd18b0c30903042351oae6fafck255d6b1058c83f1f@mail.gmail.com> <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 12:46:16AM -0800, Justin Mattock wrote:
> On Wed, Mar 4, 2009 at 11:51 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> > On Wed, Mar 4, 2009 at 10:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> On Wed, Mar 04, 2009 at 09:41:09PM -0800, Justin Mattock wrote:
> >>> From: Justin P. Mattock <justinmattock@gmail.com>
> >>>
> >>> This fixes an error when compiling the kernel.
> >>>
> >>>   CHK     include/linux/version.h
> >>>   HOSTCC  scripts/unifdef
> >>> scripts/unifdef.c:209: error: conflicting types for 'getline'
> >>> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
> >>> make[1]: *** [scripts/unifdef] Error 1
> >>> make: *** [__headers] Error 2
> >>>
> >>> --
> >>> scripts/unifdef.c  |  3 +++
> >>> 1 files changed, 3 insertions(+),0 deletions(-)
> >>>
> >>> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
> >>> ---a/scripts/unifdef.c
> >>> +++b/scripts/unifdef.c
> >>> @@ -203,1 +203,0 @@ static void             addsym(bool, bool, char *);
> >>>
> >>>
> >>> static void             done(void);
> >>> static void             error(const char *);
> >>> static int              findsym(const char *);
> >>> static void             flushline(bool);
> >>> -static Linetype         getline(void);
> >>> +static Linetype         get_line(void);
> >>> static Linetype         ifeval(const char **);
> >>> static void             ignoreoff(void);
> >>> static void             ignoreon(void);
> >>> static void             keywordedit(const char *);
> >>>
> >>>
> >>>
> >>>
> >>> @@ -509,1 +509,0 @@ process(void)
> >>>
> >>>
> >>> {
> >>>       Linetype lineval;
> >>>
> >>>       for (;;) {
> >>>               linenum++;
> >>> -               lineval = getline();
> >>> +             lineval = get_line();
> >>>               trans_table[ifstate[depth]][lineval]();
> >>>               debug("process %s -> %s depth %d",
> >>>                   linetype_name[lineval],
> >>>                   ifstate_name[ifstate[depth]], depth);
> >>>       }
> >>> }
> >>>
> >>>
> >>> @@ -528,1 +528,0 @@ static Linetype
> >>> -getline(void)
> >>> +get_line(void)
> >>> {
> >>>       const char *cp;
> >>>
> >>> --
> >>>
> >>>
> >>> keep in mind I've never created a patch before,
> >>> (so go easy on me);
> >>
> >>
> >> Hi,
> >>
> >> You forgot to put your Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> >> :)
> >>
> >> See Documentation/SubmittingPatches
> >>
> >> I don't know who is the maintainer of this file.
> >> Adding Andrew in Cc.
> >>
> >>
> >>> regards;
> >>>
> >>> --
> >>> Justin P. Mattock
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >>
> >
> > Cool,
> > thanks for the help.
> > I'll look at the doc's and google
> > as much as possible, so I get this
> > correct.
> >
> > regards;
> >
> > --
> > Justin P. Mattock
> >
> 
> O.K. after doing some reading,
> I have a better idea of how to make a
> patch. I used diff, used patch -Np1, and compiled.
> and added the signed off part.
> I'll post after this post.
> and take any suggestions on what to do next.
> 
> -- 
> Justin P. Mattock


I note that you used git right?
One thing that you can do is to use git-format-patch which does the most
part of it:

Create a local branch based on which you are working on:

git-checkout -b mybranch
//modify what you want
//And commit the changes:

git-commit -a

Once it is done, you can generate your patch by typing:

git-format-patch -p -s -1

But, all of these steps are mostly useful if you are working on a whole patchset,
usually for a single patch, just type git-diff > my_patch.diff
And add your Signed-off-by

The usual diff tool is useful when you are doing a patch on a non-git tree.
If you are on a git tree, git-diff is really easier.

And also important: always find the right persons to Cc when
you send a patch. It's easy for anyone to miss it on the whole noise.

Try to find these persons on the MAINTAINERS file, or by using git-log to find
those who recently committed the patches in this area, or if you don't find anyone,
then Cc Andrew Morton, he will route it to the appropriate maintainers.

