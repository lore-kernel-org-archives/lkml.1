Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbYEGBmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbYEGBmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYEGBlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:41:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61894 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbYEGBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:41:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oyL0UvVEPA/2HLLDNvM3y38K1aUiwq42LYkVvqAj2HLLXfRJZYwgXtxN50M5cdDyG
	dMtLtGt4QjOf0YgyV+zjQ==
Message-ID: <6599ad830805061841n57232824s451c4e8788b7864d@mail.gmail.com>
Date: Tue, 6 May 2008 18:41:39 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Cc: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Paul Jackson" <pj@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506183841.e1771032.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210101.1070205@google.com>
	 <20080506183841.e1771032.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 6:38 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 06 May 2008 18:08:17 -0700 Paul Menage <menage@google.com> wrote:
>
>  > -static int update_relax_domain_level(struct cpuset *cs, char *buf)
>  > +static int update_relax_domain_level(struct cpuset *cs, s64 val)
>  >  {
>  > -     int val = simple_strtol(buf, NULL, 10);
>  > -
>  > -     if (val < 0)
>  > +     if ((int)val < 0)
>  >               val = -1;
>  >
>
>  Are you sure about the typecast here?  If `val' has a value of say
>  0x0000_ffff_ffff_ffff then I assume the casted value will be negative, only
>  it wasn't?
>

It seems like the simplest approach - if it's outside the range of a
positive int, set it to -1.

Paul
