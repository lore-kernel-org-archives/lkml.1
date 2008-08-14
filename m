Return-Path: <linux-kernel-owner+w=401wt.eu-S1757888AbYHNIik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbYHNIik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYHNIic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:38:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2712 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYHNIib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:38:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Bkl28mtYyLtaikIM2k3lSlvu2e+z5UnvD1DLhGhv68Pgrb+BK27jTgeQ3d/HjTd6T
	5RYPdd5CplMX1g7RmbTMA==
Message-ID: <6599ad830808140138u15f516fdpace0ba455406efd4@mail.gmail.com>
Date: Thu, 14 Aug 2008 01:38:17 -0700
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][RFC] dirty balancing for cgroups
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1216043344.12595.89.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080711141511.515e69a5.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080711055926.9AF4F5A03@siro.lan>
	 <20080711161349.c5831081.kamezawa.hiroyu@jp.fujitsu.com>
	 <1216043344.12595.89.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 6:49 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> The dirty page limit avoids deadlocks under certain situations, the per
> BDI dirty limit avoids even mode deadlocks by providing isolation
> between BDIs.
>

As well as deadlocks, in the case of cgroups a big advantage of dirty
limits is that it makes it easier to "loan" memory to groups above and
beyond what they have been guaranteed. As long as we limit the
dirty/locked memory for a cgroup to its guarantee, and require any
extra memory to be clean and unlocked, then we can reclaim it in a
hurry if another cgroup (that had been guaranteed that memory) needs
it.

Paul
