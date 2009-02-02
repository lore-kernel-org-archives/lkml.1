Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZBBUjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZBBUjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZBBUjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:39:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:58700 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbZBBUja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:39:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bqc0sa4GVgS3ZNhyjnipmSSSnpLjde5FA2O5zyc5KXdD0yp/Xp+547j219mTsrC7g0
         RNRXF9f+ZsFRKuSEBdGJutuLDX6cy+B1vqWcLJzcXtg8ryxw7f/cSYJ/GNPQvlzVGTC6
         XltEg04tFKhEVb9GejMtAPvsaI2SGr4a5K3KY=
MIME-Version: 1.0
In-Reply-To: <498754EF.8090604@redhat.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090201174159.4a52e15c.akpm@linux-foundation.org>
	 <20090202064509.GA20237@redhat.com>
	 <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	 <20090202165606.GA13346@redhat.com> <498754EF.8090604@redhat.com>
Date: Mon, 2 Feb 2009 12:39:30 -0800
Message-ID: <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 12:17 PM, Ulrich Drepper <drepper@redhat.com> wrote:
> The userlevel context of the
> thread is not usable anymore.  It will have run all kinds of
> destructors.  The current behavior is AFAIK that the main thread won't
> react to any signal anymore.  That is absolutely required.

Hey Ulrich,

Thanks for articulating that requirement. I think it can be met by
extending the patch a little bit. We can keep the main thread parked
inside sys_exit /and/ get it not to react to signals internally, yet
have the external behavior that the process reacts in the normal
way to certain signals like SIGTSTP, SIGCONT, etc.
