Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZCEOsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZCEOsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZCEOsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:48:24 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:22104 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZCEOsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WSxh+npuKINySaj9bNqjzeZEAEiCE/5BeXXZqDwVbUwU0k+pN9lTaDXWUPNybZTe0L
         ma0TYnC1/OelIUZp1rFwnLhvUXrOTaZ1BtKoFXu4Fnb3ryM2xjPiPVJigaF25daVhG1/
         0/DS0C5l56AnZnmsLEHigwzvGjXL2ZZA7G3f0=
MIME-Version: 1.0
In-Reply-To: <20090305090027.GD5359@nowhere>
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>
	 <20090305060436.GA5359@nowhere>
	 <dd18b0c30903042351oae6fafck255d6b1058c83f1f@mail.gmail.com>
	 <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com>
	 <20090305090027.GD5359@nowhere>
Date: Thu, 5 Mar 2009 06:48:20 -0800
Message-ID: <dd18b0c30903050648u2b061dc1k3f967e019913b68a@mail.gmail.com>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid C 
	library confusion.
From: Justin Mattock <justinmattock@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 5, 2009 at 1:00 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Mar 05, 2009 at 12:46:16AM -0800, Justin Mattock wrote:
>> On Wed, Mar 4, 2009 at 11:51 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> > On Wed, Mar 4, 2009 at 10:04 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >> On Wed, Mar 04, 2009 at 09:41:09PM -0800, Justin Mattock wrote:
>> >>> From: Justin P. Mattock <justinmattock@gmail.com>
>> >>>
>> >>> This fixes an error when compiling the kernel.
>> >>>
>> >>>   CHK     include/linux/version.h
>> >>>   HOSTCC  scripts/unifdef
>> >>> scripts/unifdef.c:209: error: conflicting types for 'getline'
>> >>> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
>> >>> make[1]: *** [scripts/unifdef] Error 1
>> >>> make: *** [__headers] Error 2
>> >>>
>> >>> --
>> >>> scripts/unifdef.c  |  3 +++
>> >>> 1 files changed, 3 insertions(+),0 deletions(-)
>> >>>
>> >>> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
>> >>> ---a/scripts/unifdef.c
>> >>> +++b/scripts/unifdef.c
>> >>> @@ -203,1 +203,0 @@ static void             addsym(bool, bool, char *);
>> >>>
>> >>>
>> >>> static void             done(void);
>> >>> static void             error(const char *);
>> >>> static int              findsym(const char *);
>> >>> static void             flushline(bool);
>> >>> -static Linetype         getline(void);
>> >>> +static Linetype         get_line(void);
>> >>> static Linetype         ifeval(const char **);
>> >>> static void             ignoreoff(void);
>> >>> static void             ignoreon(void);
>> >>> static void             keywordedit(const char *);
>> >>>
>> >>>
>> >>>
>> >>>
>> >>> @@ -509,1 +509,0 @@ process(void)
>> >>>
>> >>>
>> >>> {
>> >>>       Linetype lineval;
>> >>>
>> >>>       for (;;) {
>> >>>               linenum++;
>> >>> -               lineval = getline();
>> >>> +             lineval = get_line();
>> >>>               trans_table[ifstate[depth]][lineval]();
>> >>>               debug("process %s -> %s depth %d",
>> >>>                   linetype_name[lineval],
>> >>>                   ifstate_name[ifstate[depth]], depth);
>> >>>       }
>> >>> }
>> >>>
>> >>>
>> >>> @@ -528,1 +528,0 @@ static Linetype
>> >>> -getline(void)
>> >>> +get_line(void)
>> >>> {
>> >>>       const char *cp;
>> >>>
>> >>> --
>> >>>
>> >>>
>> >>> keep in mind I've never created a patch before,
>> >>> (so go easy on me);
>> >>
>> >>
>> >> Hi,
>> >>
>> >> You forgot to put your Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>> >> :)
>> >>
>> >> See Documentation/SubmittingPatches
>> >>
>> >> I don't know who is the maintainer of this file.
>> >> Adding Andrew in Cc.
>> >>
>> >>
>> >>> regards;
>> >>>
>> >>> --
>> >>> Justin P. Mattock
>> >>> --
>> >>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >>> the body of a message to majordomo@vger.kernel.org
>> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>> Please read the FAQ at  http://www.tux.org/lkml/
>> >>
>> >>
>> >
>> > Cool,
>> > thanks for the help.
>> > I'll look at the doc's and google
>> > as much as possible, so I get this
>> > correct.
>> >
>> > regards;
>> >
>> > --
>> > Justin P. Mattock
>> >
>>
>> O.K. after doing some reading,
>> I have a better idea of how to make a
>> patch. I used diff, used patch -Np1, and compiled.
>> and added the signed off part.
>> I'll post after this post.
>> and take any suggestions on what to do next.
>>
>> --
>> Justin P. Mattock
>
>
> I note that you used git right?
> One thing that you can do is to use git-format-patch which does the most
> part of it:
>
> Create a local branch based on which you are working on:
>
> git-checkout -b mybranch
> //modify what you want
> //And commit the changes:
>
> git-commit -a
>
> Once it is done, you can generate your patch by typing:
>
> git-format-patch -p -s -1
>
> But, all of these steps are mostly useful if you are working on a whole patchset,
> usually for a single patch, just type git-diff > my_patch.diff
> And add your Signed-off-by
>
> The usual diff tool is useful when you are doing a patch on a non-git tree.
> If you are on a git tree, git-diff is really easier.
>
> And also important: always find the right persons to Cc when
> you send a patch. It's easy for anyone to miss it on the whole noise.
>
> Try to find these persons on the MAINTAINERS file, or by using git-log to find
> those who recently committed the patches in this area, or if you don't find anyone,
> then Cc Andrew Morton, he will route it to the appropriate maintainers.
>
>

Cool,
thanks for those pointers.
As for the first patch(admittedl I look at another patch
as an example of how it should look.) I googled
a bit, but didn't see much. Then I figured I guess
these guys manually just create these things.
(which isn't the case). All was fine until the
@@ +number -number @@ thread (part)
Which confused me a bit.
But then later on finding info on diff, and now you're pointers
with git(opens a whole new world);
I still need to do more reading up on this, So I can be prepared
in the future if this ever occurs again.

As for the patch itself. If need be I can resend with the signed off
part in the correct location, as well as everybody involved with this.
this way things are legit.


-- 
Justin P. Mattock
