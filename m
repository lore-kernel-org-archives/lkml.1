Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbZJMGNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbZJMGNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbZJMGNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:13:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:56379 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbZJMGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o+AegtF5ZNdBEHud3/F1XQfD9xaTBNh+gC91kOeCUuPprihsxrxao/0TLHzin+/DTP
         Y4HwyIgV5H7vayY7zXNs2syzD0EZTqDjyiCkxHaLAeO6aQdJbXfnNgSuJkHgxwzju3QC
         rLys9ZkNBljY80jabAJRqZ6rKMGoI7EFRun7o=
Date: Mon, 12 Oct 2009 23:12:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: bcm5974: report ABS_MT events
Message-ID: <20091013061220.GI2887@core.coreip.homeip.net>
References: <1255386223-4109-1-git-send-email-rydberg@euromail.se> <1255386223-4109-2-git-send-email-rydberg@euromail.se> <20091012154528.6830da60.akpm@linux-foundation.org> <4AD3B6E2.9020703@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD3B6E2.9020703@euromail.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 01:08:18AM +0200, Henrik Rydberg wrote:
> Andrew Morton wrote:
> > On Tue, 13 Oct 2009 00:23:43 +0200
> > "Henrik Rydberg" <rydberg@euromail.se> wrote:
> > 
> >> This patch makes bcm5974 report raw multi-touch (MT) data in the form
> >> of ABS_MT events. The module parameter (nomt) may be used to turn off
> >> the effect of this patch.
> >>
> > 
> > Why do we need a module parameter to disable the newly-added feature?
> 
> All MT events bypass the input filtering and gets sent directly to the X driver.
> Although it works as intended, without visible side effects, the stream of
> events is rather large, and since the bypassing is completely new behavior, I
> felt compelled to provide an option to turn it all off. Perhaps it is just me
> being paranoid.
> 

What is the expected rate of the events when user touches the pad with
2-3 fingers? Could you giove me estimate?

> > 
> > IMO, your first patch ("input: bcm5974: retract efi-broken
> > suspend_resume") is 2.6.32 material whereas this one is 2.6.33
> > material?
> > 
> > This assumes that the two patches can be safely separated in this
> > manner, which does appear to be the case.
> > 
> 
> I was imagining both for 2.6.33; the efi booting is just beginning to work, and
> since no distro is using it fully so far the problem currently only hits the
> adventure-seekers anyways.

I'd wait then - it works fine in non-efi mode and maybe by the time EFI
is ready reset_resume will start working as well.

-- 
Dmitry
