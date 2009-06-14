Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZFNKqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZFNKqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbZFNKqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:46:43 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:47185 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbZFNKqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DTUzn8dscoRE7lYvUhi9K7JyHqv3SzdDBNcbA2c8yg5QQHNwQ+5kG/SYOYq+6ggV2Z
         9bxBBX7cjYg7jYmpAF9E80oPpI0IGWr+V2O8f/DzaInWIbxSztkgWWqAAC0bEWUVCJTU
         dwLeSU+Zd3+v8vvFZ+ARgzxTye+M9Gakj1qbA=
MIME-Version: 1.0
In-Reply-To: <20090614104212.GA5977@localhost>
References: <1244872920-13511-1-git-send-email-vapier@gentoo.org> 
	<Pine.LNX.4.64.0906131456090.5069@sister.anvils> <20090614100110.GA19875@localhost> 
	<20090614104212.GA5977@localhost>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 06:46:24 -0400
Message-ID: <8bd0f97a0906140346t6b19f00aq29cfd4c554682f07@mail.gmail.com>
Subject: Re: [PATCH] ramfs: ignore tmpfs options when we emulate it
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:42, Wu Fengguang wrote:
> On Sun, Jun 14, 2009 at 06:01:10PM +0800, Wu Fengguang wrote:
> Sorry I take back the previous patch. It makes sense to not break
> existing user space tools, but a warning message looks OK to remind
> people of possibly unexpected behavior.
>
>                default:
>                        printk(KERN_ERR "ramfs: bad mount option: %s\n", p);
> -                       return -EINVAL;
> +                       break;

hmm, if the warning was wrapped in #ifdef CONFIG_SHMEM, i'd be ok with
this.  otherwise we end up with warnings that can (should) be ignored
when tmpfs is being emulated with ramfs.
-mike
