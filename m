Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbXEOGA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbXEOGA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 02:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbXEOGAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 02:00:14 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:23847 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbXEOGAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 02:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=L5iSvW84K+DO3z/iIwRHABw3NYw4X8bu63cAt/ngYa1bqOjcJ2Ws4ICyqK7msiVh/ZFRR6ntQ6vNaGUmR8/W3vXvZjCjK2Tuyu/6c/4b5JYRc3x8lAbaWZOJv0WyRgPZpiQkjoa4R2+6xmiPAlX9Ya5OyqYG6AmgLt76DkGRssE=
Message-ID: <4de7f8a60705142300h342f5afaxfcc3aa292949f8f4@mail.gmail.com>
Date: Tue, 15 May 2007 08:00:10 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [RFC][PATCH 3/14] Add the whiteout file type
Cc: "Bharata B Rao" <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <Pine.LNX.4.61.0705142239290.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514093943.GE4139@in.ibm.com>
	 <Pine.LNX.4.61.0705142239290.9570@yvahk01.tjqt.qr>
X-Google-Sender-Auth: 121e0c4118997146
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> On May 14 2007 15:09, Bharata B Rao wrote:
> >
> >A white-out stops the VFS from further lookups of the white-outs name and
> >returns -ENOENT. This is the same behaviour as if the filename isn't
> >found. This can be used in combination with union mounts to virtually
> >delete (white-out) files by creating a file with this file type.
> >
> >Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
> >Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> >---
> > include/linux/stat.h |    2 ++
> > 1 files changed, 2 insertions(+)
> >
> >--- a/include/linux/stat.h
> >+++ b/include/linux/stat.h
> >@@ -10,6 +10,7 @@
> > #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
> >
> > #define S_IFMT  00170000
> >+#define S_IFWHT  0160000      /* whiteout */
> > #define S_IFSOCK 0140000
> > #define S_IFLNK        0120000
> > #define S_IFREG  0100000
>
> I wonder why 110000, 130000 or 150000 could not also be used?
>

I used the S_IFWHT definition like it is referenced in stat(2). I
guess it would be a good idea to use the same flag on BSD and Linux.

As you can see in stat(2) other OS use 011, 013 and 015.
