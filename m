Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbXJWIIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbXJWIIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbXJWIIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:08:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXJWIIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:08:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=acVQBWdv1b8K/aBEvmDkPLexwWMS4XRFoYrmjUXuFq2fuTVqP9xIfrq/a3LHIi8u1
	Z1xkfVbHue+BJyKKPKd4Q==
Message-ID: <6599ad830710230108r158ac4f4tf43d5a7ce2b374d2@mail.gmail.com>
Date: Tue, 23 Oct 2007 01:08:07 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: vatsa@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <471DA974.8060509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023024036.GC3324@linux.vnet.ibm.com>
	 <6599ad830710222306m6a3e3f52k4daf501836c05274@mail.gmail.com>
	 <6599ad830710230021n536908c0xd95250f36aa8a27d@mail.gmail.com>
	 <471DA78F.4090600@linux.vnet.ibm.com>
	 <6599ad830710230053l35fffaf5ld8882eaae8b9df7c@mail.gmail.com>
	 <471DA974.8060509@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Well, without notify_on_release you can never be sure if a new task
> got added to the control group or if someone acquired a reference
> to it. I can't think of a safe way of removing control groups/cpusets
> without using notify_on_release.
>

Using notify_on_release doesn't make any guarantees that the
notification, or the action based on that notification, will occur
before the cgroup becomes busy again.

An rmdir() on a busy cgroup is perfectly safe, it just fails with
-EBUSY. I'd just like to avoid making active control file fds trigger
than failure mode.

Paul
