Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYHWL3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYHWL3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 07:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYHWL2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 07:28:54 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:58338 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbYHWL2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 07:28:53 -0400
From: Jim Meyering <jim@meyering.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Sujith.Manoharan@atheros.com,
       linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: remove useless if-before-kfree; correct misleading indentation
In-Reply-To: <1219489423.7591.480.camel@violet.holtmann.net> (Marcel
	Holtmann's message of "Sat, 23 Aug 2008 13:03:43 +0200")
References: <87zln4rzce.fsf@rho.meyering.net>
	<1219485762.7591.476.camel@violet.holtmann.net>
	<87myj4rpsa.fsf_-_@rho.meyering.net>
	<1219489423.7591.480.camel@violet.holtmann.net>
Date: Sat, 23 Aug 2008 13:28:51 +0200
Message-ID: <877ia8rmvg.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann <holtmann@linux.intel.com> wrote:
>> >> Alternatively, you could remove the nowadays-useless
>> >> "if-before-kfree" test and leave the sometimes-redundant
>> >> assignment as-is: unconditional.
>> >
>> > actually the later one is preferred. Just remove the NULL check.
>>
>> I prefer it, too, but the indentation suggested that
>> adding braces would match the author's intent.
>>
>> In case anyone is interested, I have been maintaining a patch
>> that removes *all* useless if-before-kfree tests.  I have not
>> posted it because such changes have a reputation for provoking
>> flames on this list, but now you've provoked me ;-)
>>
>>     http://meyering.net/code/remove-useless-if-before-kfree.patch
>>      74 files changed, 127 insertions(+), 250 deletions(-)
>
> I am all for this patch.
>
> Even the Glibc free() function will do an "if-before-free" :)

Hi Marcel,

Thanks for the support.

Yes, with glibc, free(NULL) is a no-op, and POSIX has required that
behavior for long enough that *all* implementations of free on reasonable
porting targets are NULL-safe these days.  There has been plenty of
discussion as I've helped a few projects clean up in this regard, e.g.,

  http://thread.gmane.org/gmane.comp.version-control.git/74187
  http://thread.gmane.org/gmane.emacs.devel/98144
  http://thread.gmane.org/gmane.comp.lib.gnulib.bugs/12712

Here are most of the projects that have endured this janitorial work:
    git
    emacs
    glibc
    gnulib
    coreutils
    freeIPA
    libvirt
    util-linux-ng
    idutils

There's even a tool to help ensure that no new useless if-before-kfree
tests sneak back in later.

    http://git.sv.gnu.org/gitweb/?p=gnulib.git;a=blob_plain;f=build-aux/useless-if-before-free
