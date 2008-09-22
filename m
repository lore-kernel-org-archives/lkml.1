Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYIVW0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYIVW0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYIVW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:26:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:61186 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753557AbYIVW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:26:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=pqndwz1t49RLNf0I1uji2Lo8gcO9Z94Egq4zzsFqRJRiT2rNN1YO/670uq1z7Ltrd
	Qozw95SZCTq9+ZSL7WBiA==
Message-ID: <532480950809221526k70fa28edx1d542a9c8a44f810@mail.gmail.com>
Date: Mon, 22 Sep 2008 15:26:17 -0700
From: "Michael Rubin" <mrubin@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Cc: righi.andrea@gmail.com, balbir@linux.vnet.ibm.com, menage@google.com,
       kamezawa.hiroyu@jp.fujitsu.com, dave@linux.vnet.ibm.com,
       chlunde@ping.uio.no, dpshah@google.com, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, agk@sourceware.org, m.innocenti@cineca.it,
       s-uchida@ap.jp.nec.com, ryov@valinux.co.jp, matt@bluehost.com,
       dradford@bluehost.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080912161050.5b6b4065.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com>
	 <20080912131816.e0cfac7a.akpm@linux-foundation.org>
	 <48CAF583.8060406@gmail.com>
	 <20080912161050.5b6b4065.akpm@linux-foundation.org>
X-GMailtapped-By: 172.24.198.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the problme we are hitting is that we cannot specify pdflush
to have background limits less than 1% of memory. I am currently
finishing up a patch right now that adds a dirty_ratio_millis
interface.  I hope to submit the patch to LKML by the end of the week.

The idea is that we don't want to break backwards compatibility and we
also don't want to have two conflicting knobs in the sysctl or
/proc/sys/vm/ space. I thought adding a new knob for those who want to
specify finer grained functionality was a compromise. So the patch has
a vm_dirty_ratio and a vm_dirty_ratio_millis interface. The first to
specify 0-100% and the second to specify .0 to .999%.

So to represent 0.125% of RAM we set
vm_dirty_ratio = 0
vm_dirty_ratio_millis = 125

The same for the background_ratio.

Any feedback?

mrubin

On Fri, Sep 12, 2008 at 4:10 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sat, 13 Sep 2008 01:04:35 +0200
> Andrea Righi <righi.andrea@gmail.com> wrote:
>
>> BTW why not use a simple dirty-ratio-in-bytes?
>
> s/ratio/amount/  ;)
>
> No particular reason - I haven't really thought about it frankly.
>
> A "ratio" might make more sense in a containerised setup, particularly
> if the container can be resized on the fly.
>
