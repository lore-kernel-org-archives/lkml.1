Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbXLGA7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbXLGA7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXLGA7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:59:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:3297 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXLGA7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:59:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hyjW5EGYP9f9DGedna+RqOluwkBAMhBNE46pkxKaNgmzeUmrCxa6qJWVTJ5jiMRK8ss4r/KTlKxZakAch184/1Jk2qks8yWIbL4fo9vx/qGSvkemYtigBpS17/qEhS3ePelV+r91ccwe+LXd953jqh3on8DIamEaLZ8YP9MqDtQ=
Message-ID: <47589AF4.6080708@gmail.com>
Date: Fri, 07 Dec 2007 09:59:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, greg@kroah.com
Subject: Re: [PATCH] depmod: sort output according to modules.order
References: <47555AF1.8090304@gmail.com> <47555C64.8070607@gmail.com> <20071205072529.GA5681@uranus.ravnborg.org> <47565452.3010800@gmail.com> <47565486.8050701@gmail.com> <20071205190609.GA14997@uranus.ravnborg.org> <47573403.1060203@gmail.com> <20071206223754.GB25209@uranus.ravnborg.org>
In-Reply-To: <20071206223754.GB25209@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> As I said, I don't think leaving duplicate lines in a file which will be
>> installed, distributed and used widely is the RTTD.  There can be other
>> uses of the file.  For example, the file can be parsed and modified by
>> distro specific module selector.  Sure, all of them can be made to deal
>> with dup entries but that's just not the right place to solve the problem.
> 
> googled a bit.
> It looks like:
> awk '!x[$0]++'
> does the trick.

Great, that's much better.  I'll give it a try.

> So we can skip the C file (good thing).

Fully agreed.

>>> And this change in Makefile.lib seems bogus:
>>> +# make sure '/' follows subdirs
>>> +subdir-y       := $(patsubst %//,%/, $(addsuffix, /,$subdir-y))
>>> +subdir-m       := $(patsubst %//,%/, $(addsuffix, /,$subdir-m))
>> Some subdir-y|m entries have following / while others don't.  subdir-y|m
>> are lax about because either way it points to subdirectory.  The above
>> two lines are to normalize them so that there's no surprises when
>> concatenating file name to it.  I think it's a good idea to have the
>> above with or without other changes.
> With this change building modpost no longer worked so kbuild
> does not like the preceeding slashes. It could be fixed but thats
> another patch.

I don't really follow what you mean here.  Do you mean with the tailing
slash normalized, modpost doesn't work anymore?  Or with the
normalization removed?

>>> subdir-y and subdir-m does not point to directories that
>>> contains modules (built-in or not) so they can be ignored for modorder.
>> I didn't know that.  Is it forced that modules can't be put in
>> subdir-y|m directories?  What happens if I do that?
> 
> I guess modules can be built as modules - but they can never be built-in.
> And if someone uses subdir-y to point to a dir with modules
> I would anyway cosider that a bug.

s/module/component which can be a dynamically loadable module or
built-in to the kernel/ in my original sentence.  I just couldn't find a
good word to use.  So, you're saying subdir-ym's can be dropped from
modorder, right?  It would be great if we can implement a safeguard to
check that subdif-ym's don't actually contain modules.

Thanks.

-- 
tejun
