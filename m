Return-Path: <linux-kernel-owner+w=401wt.eu-S933471AbXGRPny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471AbXGRPny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbXGRPnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:43:46 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:38898 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528AbXGRPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=noR8cGx8RxXyRj7tz3aey03f4WQbwVq9CS59DNP6vQGcVFlpICFvp7QedALxwUMFnf9NXzU3O4NH2UGRTxNrwhiSPCyi8HjCjAcXNJVS275vz6reNHK+XRcjG+H7b066rVxNIiBfwL5vjeOg3yRsKralqQjaNRSmCxa+ePn489Q=
Message-ID: <469E352A.90909@gmail.com>
Date: Thu, 19 Jul 2007 00:43:38 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <469B61C8.8010902@googlemail.com>	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>	 <20070718071445.GI23568@htj.dyndns.org>	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>	 <469E2A68.6010307@gmail.com> <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
In-Reply-To: <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> Well, I dunno.  Probably my taste just sucks.  Please feel free to
>> submit patches and/or suggest better ideas.
> 
> OK, for example:
> 
> sysfs_find_dirent() -- to check for -EEXIST -- should be called
> *before* we create the new dentry for the to-be-created symlink
> in the first place. [ It's weird to grab a reference on the target
> for ourselves (and in fact even allocate the new dirent for the
> to-be-created symlink) and /then/ check for erroneous usage,
> and then go about undoing all that we should never have done
> at all. ] So this test could, and should, be made earlier, IMHO.

Locking.  Otherwise, why would the code look like that in the first place?

> And some similar others ... so attached (sorry, Gmail web
> interface) please find an attempt to make sysfs_create_link look
> a trifle more like what it should look like, IMHO. The code cleanup
> also leads to fewer LOC, smaller kernel image (lesser by 308 bytes),
> and even speeding up the no-error common case of this function,
> apart from the obvious readability benefits ... it's diffed on _top_ of
> your bugfix here, but not the other patch. [ Compile-tested only. ]

Compounded if-else vs. flattened if () with common error path is pretty
much matter of being accustomed to.  I prefer the latter because it
scales better (less nesting and less need for extra intelligence as
error case grows).  As I'm already used to it, it's also easier on my
eyes.  So, unless you have more to offer, I'm not really sure whether
the patch improves the situation noticeably.

-- 
tejun
