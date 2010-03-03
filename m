Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0CCTm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:42:29 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:63634 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0CCTmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:42:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qhZ1CYlZqfTCEjshrFLRdplsdf+qOQuUNwXrUMdoFluTq/OoWYgAhBpb5wXZtMH6ai
         xmR1D10n4UHImczu6svC1OYrK2MoEJqRNawIR89z7QDfoUIOszrg+KY2RpRzx6KJfVOi
         YxfEIHVuk61/xy9w+wj5aJJL2mU4AIDcjxxaQ=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	<87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com>
Date: Wed, 03 Mar 2010 22:42:17 +0300
In-Reply-To: <20100303191613.GB18480@redhat.com> (Mike Snitzer's message of
	"Wed, 3 Mar 2010 14:16:13 -0500")
Message-ID: <87lje9kx9i.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> Linux has all sorts of internal interfaces that are "odd"... the current
> 'q->merge_bvec_fn' interface included.  But odd is not a problem (nor is
> it "broken") unless you make changes that don't consider how the current
> interface is defined.
Ok. then cant you please explain more historical questions
1) Why bio_add_page() can not add less data than requested?
   Seems that it doesn't make caller's code much complicate
   Off course barrier bio is special case. I don't consider it here.
   
2) What statement "bio_add_page() must accept at least one page"
   exactly means?
   IMHO this means that bio_add_page() must accept at least
   one page with len (PAGE_SIZE - offset). Or more restricted
   statemnt that first bio_add_page() must be always successfull.

   But currently in some places this rule treated as what all bio
   which has size less whan PAGE_SIZE are accepted. And in x86 such
   bio may has up to 8 pages/bvecs.
>
> But I digress...
>
> Mike
