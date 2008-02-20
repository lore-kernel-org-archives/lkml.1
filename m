Return-Path: <linux-kernel-owner+w=401wt.eu-S1764283AbYBTGCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764283AbYBTGCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYBTGCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:02:14 -0500
Received: from smtp-out.google.com ([216.239.33.17]:17303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYBTGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:02:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XLguNncsb19U78kkU1BEJ+yGM7cGP/1Pum6/oX+RgxmnldZ8pFFFR/k7TrK+3bjkg
	nTWFnU/GpU4RRu1GWGeWg==
Message-ID: <6599ad830802192202t19c1f597jb7927e975eb80aa6@mail.gmail.com>
Date: Tue, 19 Feb 2008 22:02:00 -0800
From: "Paul Menage" <menage@google.com>
To: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH 0/2] cgroup map files: Add a key/value map file type to cgroups
Cc: kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, balbir@in.ibm.com,
       xemul@openvz.org
In-Reply-To: <20080220054809.86BFC1E3C58@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220051544.018684000@menage.corp.google.com>
	 <20080220054809.86BFC1E3C58@siro.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 9:48 PM, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
>
> it changes the format from "%s %lld" to "%s: %llu", right?
> why?
>

The colon for consistency with maps in /proc. I think it also makes it
slightly more readable.

For %lld versus %llu - I think that cgroup resource APIs are much more
likely to need to report unsigned rather than signed values. In the
case of the memory.stat file, that's certainly the case.

But I guess there's an argument to be made that nothing's likely to
need the final 64th bit of an unsigned value, whereas the ability to
report negative numbers could potentially be useful for some cgroups.

Paul
