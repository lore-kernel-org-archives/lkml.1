Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZDMUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZDMUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZDMUgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 16:36:01 -0400
Received: from kroah.org ([198.145.64.141]:33196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752080AbZDMUgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 16:36:01 -0400
Date: Mon, 13 Apr 2009 12:47:13 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: tom.leiming@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: kzfree object in _release function
Message-ID: <20090413194709.GB6714@kroah.com>
References: <1239466586-29410-1-git-send-email-tom.leiming@gmail.com> <20090413163101.GD32368@kroah.com> <84144f020904130937w4443ed2fjc5645824fd1377f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020904130937w4443ed2fjc5645824fd1377f@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 07:37:47PM +0300, Pekka Enberg wrote:
> Hi Greg,
> 
> On Mon, Apr 13, 2009 at 7:31 PM, Greg KH <greg@kroah.com> wrote:
> > On Sun, Apr 12, 2009 at 12:16:26AM +0800, tom.leiming@gmail.com wrote:
> >> From: Ming Lei <tom.leiming@gmail.com>
> >>
> >> It helps to troubleshoot the __buggy__ case, in which
> >> unreferenced objects are still accessed, using kzfree
> >> to free objects safely in _release function.
> >>
> >> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >> ---
> >>  lib/kobject.c |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/lib/kobject.c b/lib/kobject.c
> >> index a6dec32..cb5a562 100644
> >> --- a/lib/kobject.c
> >> +++ b/lib/kobject.c
> >> @@ -597,7 +597,7 @@ void kobject_put(struct kobject *kobj)
> >>  static void dynamic_kobj_release(struct kobject *kobj)
> >>  {
> >>       pr_debug("kobject: (%p): %s\n", kobj, __func__);
> >> -     kfree(kobj);
> >> +     kzfree(kobj);
> >>  }
> >>
> >>  static struct kobj_type dynamic_kobj_ktype = {
> >> @@ -762,7 +762,7 @@ static void kset_release(struct kobject *kobj)
> >>       struct kset *kset = container_of(kobj, struct kset, kobj);
> >>       pr_debug("kobject: '%s' (%p): %s\n",
> >>                kobject_name(kobj), kobj, __func__);
> >> -     kfree(kset);
> >> +     kzfree(kset);
> >
> >
> > What about slab-poisoning?  Shouldn't we just rely on that instead?
> 
> Yes, you should. kzfree() strictly for cases where _correctness_ of
> the program requires it (i.e. security concerns).

Thanks for letting us know.  As such, I'll not be applying this patch.

greg k-h
