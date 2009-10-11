Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbZJKMJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbZJKMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 08:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbZJKMJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 08:09:25 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:40400 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156AbZJKMJY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 08:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rAomUietOV0SY4hQTXWS0OjETOovjvjZhG2evy4SHbRoLFYrv+TuzNqNSmpFpX9IHW
         RHKnV2QC6NZ6wmEY2rvhkaG9HF8Q3/kuCUxb77LpytpqwfnCKFhuEjG1HlxVCvkpwgST
         BrpSGw6VOj0cINgR/z3kDyvl+Tr50ncKxF3X4=
MIME-Version: 1.0
In-Reply-To: <20090729171248.764570f2.akpm@linux-foundation.org>
References: <1244538071-992-1-git-send-email-alexander.shishckin@gmail.com>
	 <20090729171248.764570f2.akpm@linux-foundation.org>
Date: Sun, 11 Oct 2009 15:08:47 +0300
Message-ID: <71a0d6ff0910110508t11da5f62x34a7a8886c087a0b@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] RFC: List per-process file descriptor 
	consumption when hitting file-max
From: Alexander Shishkin <alexander.shishckin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/30 Andrew Morton <akpm@linux-foundation.org>:
> If there's some reason why the problem is particularly severe and
> particularly hard to resolve by other means then sure, perhaps explicit
> kernel support is justified.  But is that the case with this specific
> userspace bug?

Well, this can be figured by userspace by traversing procfs and
counting entries of fd/ for each, but that is likely to require more
available file descriptors and given we are at the point when the
limit is hit, this may not work. There is, of course, a good chance
that the process that tried to open the one-too-many descriptor is
going to crash upon failing to do so (and thus free a bunch of
descriptors), but that is going to create more confusion. Most of the
time, the application that crashes when file-max is reached is not the
one that ate them all.

So, all in all, in certain cases there's no other way to figure out
who was leaking descriptors.

Regards,
--
Alex
