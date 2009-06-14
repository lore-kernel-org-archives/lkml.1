Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZFNL1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZFNL1F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 07:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbZFNL0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 07:26:55 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:45643 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbZFNL0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 07:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=R6oFjft4Kz5swJhXVlzs9TnyiO7/4BX1k9LmfHvJOkpS/GoSeFahqgWg9N5k8uZxUR
         o+ABvH2vS1c06luzt3CpKKWcXc/n2xKDAtjYTZCXPE6FhuvP91weGDbdkVR2hkR9i9v4
         CWMGrU0I2wbffcoVS1sBCVU+VxAC29ZK9BhYI=
MIME-Version: 1.0
In-Reply-To: <20090614111440.GC6046@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> 
	<Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost> 
	<20090614104212.GA5977@localhost> <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com> 
	<20090614111440.GC6046@localhost>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 07:26:37 -0400
Message-ID: <8bd0f97a0906140426g5c9ad183qa258be91c17c929d@mail.gmail.com>
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

On Sun, Jun 14, 2009 at 07:14, Wu Fengguang wrote:
> On Sun, Jun 14, 2009 at 06:46:24PM +0800, Mike Frysinger wrote:
>> On Sun, Jun 14, 2009 at 06:42, Wu Fengguang wrote:
>> > On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
>> > Sorry I take back the previous patch. It makes sense to not break
>> > existing user space tools, but a warning message looks OK to remind
>> > people of possibly unexpected behavior.
>> >
>> >                default:
>> >                        printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
>> > -                       return -EINVAL;
>> > +                       break;
>>
>> hmm, if the warning was wrapped in #ifdef CONFIG_SHMEM, i'd be ok with
>> this.  otherwise we end up with warnings that can (should) be ignored
>> when tmpfs is being emulated with ramfs.
>
> We may change the "ramfs:" accordingly. But *silently* ignoring
> options is bad anyway?

i really hate nitpicking such minor shit, but reality is that output
displayed in the kernel log that is incorrect is going to cause me
grief via customer support, updating documentation, adding FAQs,
etc... and i doubt i'm the only one here.

my requirement is simple: valid tmpfs options should be silently
consumed (i.e. ignored) when tmpfs is being emulated by ramfs (i.e.
CONFIG_SHMEM=n).

so how about:
default:
    if (!strcmp(sb->s_id, "ramfs"))
        printk(KERN_WARNING "%s: ignoring mount option: %s\n", sb->s_id, p);
    break;
-mike
