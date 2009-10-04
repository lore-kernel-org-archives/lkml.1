Return-Path: <linux-kernel-owner+w=401wt.eu-S1757614AbZJDSaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614AbZJDSaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZJDSaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:30:11 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:60907 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZJDSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l+5OQ3t/40ghO92b627axFoTEvAv4eJVYFYcD5t1u4rtG/b/AbujTE37pJeLfrlpY3
         OBDjFSzomjxwpV1jzE1z2JQ2XjhkWYG40NusGIHwzaAibrJ5pZXeTdgizSO7q5+0J+8H
         zLWWP/5rR+71WrAZD3vEXHFINeMV5G6iyJ8r4=
MIME-Version: 1.0
In-Reply-To: <20091004173636.GC26573@kernel.dk>
References: <200910041837.34546.czoccolo@gmail.com>
	 <20091004173636.GC26573@kernel.dk>
Date: Sun, 4 Oct 2009 20:29:33 +0200
Message-ID: <4e5e476b0910041129o91268f0uc550640d62d82aab@mail.gmail.com>
Subject: Re: [PATCH] cfq: enable idle for seeky processes on rotational NCQ 
	devices
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 4, 2009 at 7:36 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> I think this one is a bit problematic. What I'd like seeky processes to
> do is enable 'idle unless other sync read comes in' for such cases,
> otherwise it will cost us a lot of performance on the seeky vs seeky
> cases because we don't get to take advantage of queuing.

Are we sure that queuing is beneficial in this workload, on non-raid
rotational devices?
If the seeks are still quite local (e.g. when accessing a single
file), given that seek time is proportional to seek length, idling
should provide higher throughput.

Anyway, I'm working on an other patch that will group together all
seeky queues and dispatch them without idling, and idle only on the
last one, so if you prefer, this can be postponed until the other
patch is ready.

Thanks,
Corrado

> It would be
> perfectly fine to continue waiting if just async IO comes in, but if we
> have other seeky readers then they should get a turn.
>
> I realize that this does skew potential priority issues.
>
> --
> Jens Axboe
>
