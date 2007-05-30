Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbXE3TUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbXE3TUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXE3TUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:20:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:1875 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbXE3TUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:20:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dFGrAKBeL93u28A9MWDMTHkh2Re/eFqrucA625gl/tqBQhA6sTiOkpym13/rmn7hHmll21/ZFJmA/4mVtZ80bUGmqForbVeoU3/P43kkaJKO8QHdsVCAXzSMJE067LHLRmyjQT8T6l6ypHGtAuf0WdYf45GTf0Ltgt4NpNMEsLI=
Message-ID: <465DCE84.1090403@gmail.com>
Date: Wed, 30 May 2007 20:20:36 +0100
From: Michael-Luke Jones <mike.luke.jones@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, Mark Adler <madler@alumni.caltech.edu>,
       jloup@gzip.org
Subject: Re: [-mm] Move zlib compression library to common directory [TAKE
 TWO]
References: <465C3973.3090303@gmail.com> <465C5549.4050101@gmail.com> <a781481a0705301105n37309182xdf56fb99a3392430@mail.gmail.com>
In-Reply-To: <a781481a0705301105n37309182xdf56fb99a3392430@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Ugh, I wish you had held on from this patch till the original thread
> discussing this reached some conclusion ... from Mark's response
> there it does seem PRESET_DICT is clearly an implementation
> (and not interface) detail -- which means to me that it must continue
> to live in zutil.h (the private header) ... but then, this change is
> clearly not so critical either, so it doesn't matter much, I guess.

Satyam: Sorry about this, I wrote this before the conversation on this
point started, expecting the discussion to happen here. My hope was to
see if this minimal change to export PRESET_DICT was acceptable (if not
ideal). Given that practically all of the implementation details are
currently exported, it's probably an improvement to only export one :)

Andrew: The main reason for this change is to allow a private header to
be moved from include/linux/ to this private folder. It's already been
used apparently inappropriately by JFFS2 compression code. Minimal code
changes, lots of file moving (as I'm sure you can see)...

I managed to get the patch to apply to a fresh tree using 'git apply',
which may well mean that I didn't understand your comment that "the
parts which move files around were communicated via git metadata, not
diffs".

Given that, since I wrote this patch, no-one has actually said anything
positive about it, there's probably not much point picking it up until
people have worked out exactly what to do with JFFS2's inappropriate use
of the public-private zutil.h header. At least it's just JFFS2 :)

> [ Added zlib authors Mark Adler and Jean-Loup Gailly on this
> thread too. ]

Thanks, I should have CCed the authors/maintainers originally.

> Satyam

Michael-Luke

(PS: The stern warning is also present in the other private zlib header
files.)

