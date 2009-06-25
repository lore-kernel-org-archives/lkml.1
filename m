Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbZFYAHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbZFYAHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZFYAHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:07:31 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:64355 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZFYAHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=P7eImIsN2UHY669tn6cDEa8s1JMLQpJ7LwOuDduhiBwrk7FEKRWS22rXY6QgfSK7WQ
         3eFh/WDUD0gySnTLGE9ZW8dG6oPtMeiNfYzgSbfIDUAak1Tz9b9KFvYYmtyeu8ZQTX4J
         idwKGq9McLigZuV5idrQ5Zk7Rfi8pkgkFM4bA=
MIME-Version: 1.0
In-Reply-To: <20090624235856.GZ8633@ZenIV.linux.org.uk>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com> 
	<20090624235856.GZ8633@ZenIV.linux.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 20:07:12 -0400
Message-ID: <8bd0f97a0906241707k14d09df5t6aa3229ed115b478@mail.gmail.com>
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not 
	mounted
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 19:58, Al Viro wrote:
> On Thu, Jun 25, 2009 at 01:00:56AM +0200, Denys Vlasenko wrote:
>> More elegant way is to execute /proc/self/exe.
>> This works just fine as long as /proc is mounted.
>
> So mount it.

well, in the busybox case, in order to run mount you might have to
exec yourself first ...

> No.  This is just plain sick.  Magical pathnames have no business being
> in the kernel.  If procfs is too much for your sensitive soul, do an
> extremely trimmed-down version that would consist of *one* *file* (yes,
> as root and only node on fs).  Said file being a procfs-style symlink,
> doing exactly what /proc/self/exec would do.
>
> On such system you can just mkdir /proc/self, touch /proc/self/exec,
> mount -t self_exec none /proc/self/exec and be done with that.  No
> magic needed, end of the story.

if that is acceptable, how about a special binfmt that depends on
EMBEDDED and we put the magic there.
-mike
