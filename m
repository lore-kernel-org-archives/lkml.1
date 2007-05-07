Return-Path: <linux-kernel-owner+w=401wt.eu-S967085AbXEGW35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967085AbXEGW35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966550AbXEGW3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:29:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:47575 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966716AbXEGW3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iXYaKfA1WwQB1icQPHPIv1MHsIK1upWQCwSzro0GqkJaIw2ZD3lUKDHVUMjK7jRkEbW1LC/rMjDvAh2aPxMvan4+amBJ/sJCX1OheKggvd4Qs0LQwJhPhtwB/WNhOfSRDOcf3rkhlb6DkyUHVNA0iHFLPpR3qRNskiZYdMNsAJM=
Message-ID: <12c511ca0705071529w38f71b09je0d9b460c7bc3025@mail.gmail.com>
Date: Mon, 7 May 2007 15:29:52 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/3] kbuild: complain about missing system calls.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Kees Cook" <kees@outflux.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <20070321222236.GB22623@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <20070320103151.f65c81b6.randy.dunlap@oracle.com>
	 <20070320192016.GC22797@outflux.net>
	 <20070320214714.0e584cd4.akpm@linux-foundation.org>
	 <20070321221905.GA22623@uranus.ravnborg.org>
	 <20070321222236.GB22623@uranus.ravnborg.org>
X-Google-Sender-Auth: e7ddac966635ce32
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> Most system calls seem to get added to i386 first. This patch
> automatically generates a warning for any new system call which is
> implemented on i386 but not the architecture currently being compiled.

This is now upstream, and so I see a bunch of warnings for every ia64
build.  Some of them are real, I need to add some syscalls, but there
are a few bogus ones because ia64 chose different names (e.g. we have
a sys_clone() that glibc uses to implement fork() and vfork()).

Just checking that the right way for me to shut checksyscalls.sh up is
to add:

#define __IGNORE_fork
#define __IGNORE_vfork

etc. to include/asm-ia64/unistd.h for each of the bogus ones.  Or is there
some other preferred mechanism?

-Tony
