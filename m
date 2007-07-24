Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbXGXNIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbXGXNIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXGXNIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:08:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8009 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXGXNIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:08:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OMHaSFI1GgWWVD/dsiOXrJ6DZnvG8lx2HxRhRhm7ASRFrkhtQOk8i511bvyCVWk8D3HkWiof2oYbT7ehzU99G69ILNztVdOKMkrXK9HGkfZj1zuXh8WN8h1qEj7/PSAndMgzjdqmL5O9fwscktF5JVtJsHFBCsEvUaI/8cF8zo4=
Message-ID: <d120d5000707240608l25e07de1we6f0b4d92ab6a4a3@mail.gmail.com>
Date: Tue, 24 Jul 2007 09:08:36 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46A5E034.2030205@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <740c90243aaa6f6d4640d71230c4fa27@pinky>
	 <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org>
	 <20070724021526.3d92286b.akpm@linux-foundation.org>
	 <46A5E034.2030205@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Andy Whitcroft <apw@shadowen.org> wrote:
> Andrew Morton wrote:
> > On Tue, 24 Jul 2007 10:06:51 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> >
> >>> This is a royal pain, since it now throws an ERROR for the obviously
> >>> preferable piece of code below:
> >>>
> >>> if (err) {
> >>>     do_something();
> >>>     return -ERR;
> >>> } else {
> >>>     do_somthing_else();
> >>> }
> >> Hmmm, is that obviouly nicer than the below?  Its fully a line longer
> >> for no benefit.  But ignoring that, this seems to have snuck in to
> >> CodingStyle hmmm ... will see what I can do if anything to stop these
> >> being picked up I guess.
> >>
> >>      if (err) {
> >>              do_something();
> >>              return -ERR;
> >>      } else
> >>              do_something_else();
> >
> > The kool kids on linux-usb-devel largely ended up deciding that the second
> > version looks dorky.
> >
> > Especially if there's a comment over do_something_else(), and if there's
> > not a comment, perhaps there should be?
> >
> >> Andrew, as you merged the change to CodingStyle I'll take that as your
> >> being ok with these being accepted.
> >
> > It's very marginal and is sure to get people hot and bothered.  I'd suggest
> > that checkpatch be neutral on that.
>
> Ok, now if either the preceeding block or following block has {}'s then
> we don't report this block for being one line long.  We will miss some
> this way, but hey.
>

It also complains on the following:

+       if (retval && !--handle->open) {
+               /*
+                * Make sure we are not delivering any more events
+                * through this handle
+                */
+               synchronize_sched();
+       }

There is no way I'll drop braces there. You should probably not
exclude comments from line count when making decision if braces are
needed.

-- 
Dmitry
