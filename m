Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZIUOKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZIUOKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbZIUOKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:10:34 -0400
Received: from mail-yx0-f183.google.com ([209.85.210.183]:55763 "EHLO
	mail-yx0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbZIUOKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=n/Ueo2AYHpFZmm1KB8GZpvCkgyiV1kCFlIuwBARTkLhW8cA5T/Nuq8dltlAMrFDrzN
         0bGQv0mQNSq3MJav15/GtW6eBKv80PDmZS3W6jLEaIZLk4EQ7mRbBYK+KidHgW/5DAqs
         +jLUdFHCKN2VvV47eJ/A09nwI1vXL/UGAsdII=
MIME-Version: 1.0
In-Reply-To: <20090921140220.GD14381@ZenIV.linux.org.uk>
References: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu> <E1MpiMo-0005h9-DG@pomaz-ex.szeredi.hu> 
	<20090921140220.GD14381@ZenIV.linux.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Sep 2009 10:10:17 -0400
Message-ID: <8bd0f97a0909210710h5bb75bcdwb666b51a9155a70a@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: fix d_path() for unreachable paths
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de,
       hugh.dickins@tiscali.co.uk, matthew@wil.cx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:02, Al Viro wrote:
> * blackfin cplbinfo: utter crap; it's used to decide which procfs file
> is being opened - by dumping full pathname into a (on-stack) buffer
> and then parsing it.  Stupid *and* broken.

it works without having to copy & paste the same exact structures over
and over.  a suggestion as how to do it cleanly without bloating the
code is certainly welcome.  it doesnt really matter that it's on the
stack as the usage is small and d_path() is given the size of the
buffer, so it isnt going to overflow.

> * blackfin traps.c:decode_address(): for one thing, pathnames has been
> known to be longer than 256 bytes.

we know the paths are longer than 256 bytes.  the output is to give a
reasonable idea of what is crashing.  realistically, nothing
executable resides in a 256+ byte path on an embedded system.

>  For another... locking in that loop
> over processes and VMAs of each looks very suspicios, while we are at it.

we've reviewed it several times and exercised it in multiple ways.  so
unless you have a real idea of something being wrong, the code has
been vetted heavily.
-mike
