Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXBLWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXBLWJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030203AbXBLWJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:09:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:62990 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030202AbXBLWJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=totEX9gvLGhRKxfOWmARfWIwPNUFT0FCXGMzE9wGU9XFn/UVy/vnec6Nu4A2wtPjbvtUV7MZ21sCi0bHZ0yggxdlYxT9oTJPoeotiMtEgl/qtmD973CL6tE7g/c7ykuR3zBCfHM6/bwjqv+dHgmUAJ8+CT/wIXpeomJ74oFxdyM=
Message-ID: <12c511ca0702121409t30e126dfh445d13dd2f637e08@mail.gmail.com>
Date: Mon, 12 Feb 2007 14:09:49 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: [patch 3/3, resend] kbuild: correctly skip tilded backups in localversion files
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Bastian Blank" <bastian@waldi.eu.org>,
       "Sam Ravnborg" <sam@ravnborg.org>
In-Reply-To: <20070206012208.050237000@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070206011819.160359000@flower.upol.cz>
	 <20070206012208.050237000@flower.upol.cz>
X-Google-Sender-Auth: 613f6d9594d01996
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> kbuild: correctly skip tilded backups in localversion files
>
>  Tildes as in path as in filenames are handled correctly now:
>  only files, containing tilde '~', are backups, thus are not valid.

Git bisect fingers this patch (which is in Linus' tree as commit
76c329563c5b8663ef27eb1bd195885ab826cbd0) as the culprit
for double adding the contents of the localversion file.  E.g.

$ echo -tiger-smp > localversion
$ make prepare
$ make kernelrelease
2.6.20-tiger-smp-tiger-smp

-Tony
