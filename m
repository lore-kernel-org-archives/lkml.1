Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZIVQuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZIVQuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZIVQuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:50:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZIVQuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:50:18 -0400
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <20090922143223.GA31702@elte.hu>
References: <4AB3CDEC.5050902@zytor.com>
	 <1253342422-13811-1-git-send-email-avi@redhat.com>
	 <4AB8980D.5070803@redhat.com>  <20090922143223.GA31702@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:50:05 +0200
Message-Id: <1253638205.18939.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:32 +0200, Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > On 09/19/2009 09:40 AM, Avi Kivity wrote:
> >> Add a general per-cpu notifier that is called whenever the kernel is
> >> about to return to userspace.  The notifier uses a thread_info flag
> >> and existing checks, so there is no impact on user return or context
> >> switch fast paths.
> >>    
> >
> > Ingo/Peter?
> 
> Would be nice to convert some existing open-coded return-to-user-space 
> logic to this facility. One such candidate would be lockdep_sys_exit?

And here I was thinking this was one of the hottest code paths in the
whole kernel...

