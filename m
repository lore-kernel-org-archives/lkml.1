Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZASIKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZASIKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZASIKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:10:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:4424 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZASIKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:10:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rc+GO4NEzLOC2TeeR/9LsaqLgLZZiqie5WH8DKmUHOZXJcL9XFwb7DdZ3aBkbWJuVR
         pBxKMe45V6FO1P8cRcJT6nUZnZe5Y4VxzqbBJ8fNc0oEPEYqQYstvdp1QJX+2Gzyt/ui
         4RJ1Ri9xXk1Z/hRVwIo0DDZcTyPzCQLPR6Rn0=
Subject: Re: [PATCH] fbmem: fix copy_from/to_user() with mutex held
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: righi.andrea@gmail.com, Johannes Weiner <hannes@cmpxchg.org>,
       Dave Jones <davej@redhat.com>, Johannes Weiner <hannes@saeurebad.de>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49743444.8070206@s5r6.in-berlin.de>
References: <20090117231925.GA28055@redhat.com>
	 <20090118020038.GA17489@cmpxchg.org> <49738E4B.1030200@gmail.com>
	 <497432B0.1080201@s5r6.in-berlin.de>  <49743444.8070206@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 00:10:39 -0800
Message-Id: <1232352639.5570.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 09:05 +0100, Stefan Richter wrote:
> Stefan Richter wrote:
> > Andrea Righi wrote:
> >> +struct fb_info *get_fb_info(struct fb_info *info)
> >> +__acquires(&info->lock)
> >> +{
> >> +	mutex_lock(&info->lock);
> >> +	if (!info->fbops) {
> >> +		mutex_unlock(&info->lock);
> >> +		return NULL;
> >> +	}
> >> +	return info;
> >> +}
> >> +
> >> +void put_fb_info(struct fb_info *info)
> >> +__releases(&info->lock)
> >> +{
> >> +	mutex_unlock(&info->lock);
> >> +}
> >> +
> > 
> > These are IMO bad function names.
> 
> PS:  The return value of the mutex_lock wrapper is also bad.  A bool or
> int would IMO be clearer, similar to the return value of mutex_trylock.

That, and there is no possible way to get the sparse annotations right
for that function, which means you'll get no help from sparse in lock
checking.

So I'd suggest just opencoding these where needed instead of the
wrappers.

Harvey

