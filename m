Return-Path: <linux-kernel-owner+w=401wt.eu-S1750725AbXBSJGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750725AbXBSJGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXBSJGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:06:23 -0500
Received: from smtp-out.google.com ([216.239.33.17]:6287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXBSJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:06:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eK3aDhmqs4LJI7TLlk2BNSP6ytpLe1wVziDYcskhpkFM5mWJz04VZr/HUuidspmAe
	bnDpGn68Sejh9Jfq8AWug==
Message-ID: <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com>
Date: Mon, 19 Feb 2007 01:06:10 -0800
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH][0/4] Memory controller (RSS Control)
Cc: "Balbir Singh" <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-mm@kvack.org, svaidy@linux.vnet.ibm.com, devel@openvz.org
In-Reply-To: <20070219005441.7fa0eccc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
	 <20070219005441.7fa0eccc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Alas, I fear this might have quite bad worst-case behaviour.  One small
> container which is under constant memory pressure will churn the
> system-wide LRUs like mad, and will consume rather a lot of system time.
> So it's a point at which container A can deleteriously affect things which
> are running in other containers, which is exactly what we're supposed to
> not do.

I think it's OK for a container to consume lots of system time during
reclaim, as long as we can account that time to the container involved
(i.e. if it's done during direct reclaim rather than by something like
kswapd).

Churning the LRU could well be bad though, I agree.

Paul
