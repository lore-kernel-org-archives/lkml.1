Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060Ab0ANM33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab0ANM33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 07:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854Ab0ANM32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 07:29:28 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:57670 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0ANM31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 07:29:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T0MtKzIF60ySqBvu03GzgVC/8wi0YqvQEX0Ad6geajUWFB+cAt7kiys/RxGg4mXNgk
         508Po0ed9VdLk2DZoNKY15P7cHJ43NbAOAa7QigEAM2ZHWt9DMXaE3Njd+YFxuBaT4rj
         OszVKDaGb7nt+b0rARI8ILpJLAJlA5TfvHDnw=
Date: Thu, 14 Jan 2010 13:29:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 3/6] perf: Round robin groups of events using
	list_rotate_left()
Message-ID: <20100114122921.GD5033@nowhere>
References: <1263087500-14215-1-git-send-regression-fweisbec@gmail.com> <1263087500-14215-4-git-send-regression-fweisbec@gmail.com> <1263471922.4244.311.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263471922.4244.311.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 01:25:22PM +0100, Peter Zijlstra wrote:
> On Sun, 2010-01-10 at 02:38 +0100, Frederic Weisbecker wrote:
> > This is more proper that doing it through a list_for_each_entry()
> > that breaks after the first entry.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Paul Mackerras <paulus@samba.org>
> > ---
> 
> > +	list_rotate_left(&ctx->pinned_groups);
> > +	list_rotate_left(&ctx->flexible_groups);
> 
> Just wondering, pinned events were supposed to be on the pmu at all
> times, right?


Yeah, but the previous version that was using a global
list rotated the whole. So, somehow to keep the same
bahaviour, I also rotate the pinned group, even
if it makes no sense :-)

But there is a subsequent patch in the same set
that removes the rotating of pinned groups.

