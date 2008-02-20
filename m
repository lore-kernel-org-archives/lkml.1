Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYBTGZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYBTGZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYBTGZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:25:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:36710 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYBTGZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:25:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ECCaaTvS1xq3ORsKyoIFMgtsKacjMGWslxcKSaAq7oYbrx//AvYwZKTd8eYDSZ9zf
	G/NaULWnP+Xr9l4pKQ27Q==
Message-ID: <6599ad830802192225t5eb31cb5q9fca5b6ef2e03d71@mail.gmail.com>
Date: Tue, 19 Feb 2008 22:25:34 -0800
From: "Paul Menage" <menage@google.com>
To: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH 0/2] cgroup map files: Add a key/value map file type to cgroups
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
In-Reply-To: <20080220061444.D65BD1E3C11@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802192202t19c1f597jb7927e975eb80aa6@mail.gmail.com>
	 <20080220061444.D65BD1E3C11@siro.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 10:14 PM, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
> > On Feb 19, 2008 9:48 PM, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
> > >
> > > it changes the format from "%s %lld" to "%s: %llu", right?
> > > why?
> > >
> >
> > The colon for consistency with maps in /proc. I think it also makes it
> > slightly more readable.
>
> can you be a little more specific?
>
> i object against the colon because i want to use the same parser for
> /proc/vmstat, which doesn't have colons.

Ah. This /proc behaviour of having multiple formats for reporting the
same kind of data (compare with /proc/meminfo, which does use colons)
is the kind of thing that I want to avoid with cgroups. i.e. if two
cgroup subsystems are both reporting the same kind of structured data,
then they should both use the same output format.

I guess since /proc has both styles, and memory.stat is the first file
reporting key/value pairs in cgroups, you get to call the format. OK,
I'll zap the colon.

Paul
