Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZFXXhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZFXXhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756022AbZFXXhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:37:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20780 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbZFXXhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:37:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=gWP/OZ/PNtzBqaI+W9F16nxJFnw5utUxWWMdZ/IJSsVcPjKUdoIPe9u5gIlXYZ4D0
	1Z7zG7QKtIcEDJrZxJ4qA==
MIME-Version: 1.0
In-Reply-To: <1245886161.32124.238.camel@desktop>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245849223.32124.112.camel@desktop>
	 <a55d774e0906241514w761f86fva294784583cdd8a4@mail.gmail.com>
	 <1245883778.32124.214.camel@desktop>
	 <a55d774e0906241605u1e7aa816n823aad517f05a1e1@mail.gmail.com>
	 <1245886161.32124.238.camel@desktop>
Date: Wed, 24 Jun 2009 16:37:37 -0700
Message-ID: <a55d774e0906241637y58739710jffd9e5ee6a847b7@mail.gmail.com>
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny && usage
From: Brian Swetland <swetland@google.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
       hackbod@android.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 4:29 PM, Daniel Walker<dwalker@fifo99.com> wrote:
>> Unfortunately, no.  However, the generic changes tend to be
>> self-contained (binder, logger, etc) and not necessary for core msm7k
>> support.  The one set of changes that does touch both generic and
>> platform code is the wakelock/suspendblock stuff, which some of the
>> drivers make use of, but that's usually not very invasive.
>>
>> http://android.git.kernel.org/?p=kernel/msm.git;a=shortlog;h=refs/heads/android-msm-2.6.29
>> is the most up to date msm7k tree.
>
> Having a tree with strictly msm changes is kind of a minimum requirement
> for mainline. It would be good to split your tree into branches with
> specific functionality. For instance one branch with just msm, one
> branch with just wakelocks, and one branch with driver changes (or one
> branch per driver change). Then you can merge all those branches
> together which would make your unified kernel.

For stuff going upstream in the past (earlier contributions via
lakml), I've generally pulled out series of patches for review and
built up a for-rmk branch to pull from or the like.

We tend to rebase onto a kernel release (last time was 2.6.29) and
work on that towards a platform release, and simultaneously we can be
feeding patches upstream (we should be doing more of this, obviously).
 When we rebase up to the next release we snap to, we pick up anything
that's already gone upstream, and in theory, over time the delta
between our tree and mainline shrinks.  This was the case when we
moved to .29 from .27 (as a bunch of msm7k patches had gone into .28).

Brian
