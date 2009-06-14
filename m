Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZFNKUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZFNKUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZFNKU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:20:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:59383 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZFNKU2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:20:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Th9E/ESuDweOwFG00rttrzOocKYsZfZOeRQdBVGJABRE10TURH7MEA9sgv0rgm4o+7
         axFnpQEvJEPLMOap1NNYnSuL8nJVucbVZeUlnTx/yCUvFuQPH2nkwND9BOW9zUAnquHn
         qLel6v3JNZOOiqy/lhak0kiZJMwr8e9llHIrM=
MIME-Version: 1.0
In-Reply-To: <20090614100110.GA19875@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> 
	<Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 06:20:11 -0400
Message-ID: <8bd0f97a0906140320r41b37f7by362d23fa3242234a@mail.gmail.com>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:01, Wu Fengguang wrote:
> On Sat, Jun 13, 2009 at 10:15:51PM +0800, Hugh Dickins wrote:
>> On Sat, 13 Jun 2009, Mike Frysinger wrote:
>> > On systems where CONFIG_SHMEM is disabled, mounting tmpfs filesystems can
>> > fail when tmpfs options are used.  This is because tmpfs creates a small
>> > wrapper around ramfs which rejects unknown options, and ramfs itself only
>> > supports a tiny subset of what tmpfs supports.  This makes it pretty hard
>> > to use the same userspace systems across different configuration systems.
>> > As such, ramfs should ignore the tmpfs options when tmpfs is merely a
>> > wrapper around ramfs.
>>
>> Yes, indeed, thanks a lot for reporting this.
>>
>> But I'm uneasy with making ramfs behaviour differ with CONFIG_SHMEM
>> (perhaps that's silly: certainly tmpfs behaviour differs with it),
>> and uneasy with coding a list of options we need to remember to keep
>> in synch with mm/shmem.c.  It's easier to justify ignoring all options,
>> than rejecting some while ignoring others yet not respecting them.
>
> We can avoid the burden of syncing a list of options between
> ramfs<>tmpfs by a slightly differently patch. Hopefully this makes
> ramfs behave like other filesystems when used standalone.

i think Hugh's suggestion to change the behavior of ramfs back to the
way it has always been (ignore unknown options) is the way to go
rather than making it change behavior based on configuration
-mike
