Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZFARCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZFARCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZFARCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:02:08 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:57477 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZFARCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bmNIkiWWJjSxo6TGf+Sznxs9nDDcljwFuitC4OWEt05o+5IbSz6Pm1zXeVuJoP+26A
         zjmbkfszOswGJF2I5t7u0ZOGSxWV6M8SeKum4BOGRnimGMxyc97SR69SDwZgs67SaeT1
         MdehMft9hqbvEMwl3YasYl/Ufc/r84T4EbgOw=
Message-ID: <4A240993.8030409@gmail.com>
Date: Mon, 01 Jun 2009 19:02:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts: allow docproc invocation from external
References: <1243785934-13936-1-git-send-email-jirislaby@gmail.com> <4A23FC2C.4060602@oracle.com>
In-Reply-To: <4A23FC2C.4060602@oracle.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2009 06:05 PM, Randy Dunlap wrote:
> Jiri Slaby wrote:
>> - getcwd returns path without a slash at the end, add the slash
> 
> Hi Jiri,
> 
> This part (above) fixes a bug, right?

Yes, but the bug is not triggered when building from a kernel tree.

>> - add KBUILD_SRC env support, so that we can specify path for
>>   kernel (to know where scripts/kernel-doc resides) and SRCTREE
>>   (for searching files referenced in .tmpl) separately
> 
> Can you explain your usage a bit more so that I can understand some
> justification for this change?  (not that I'm objecting to it)

Sure, I have out-of-kernel drivers (which I plan to merge, but keep
out-of-tree development anyway) and have this in a makefile:
%.xml: %.tmpl
        KBUILD_SRC=$(KSRC) $(KDIR)/scripts/basic/docproc doc $^ > $@
so that I can build documentation from a .tmpl file for those drivers.
SRCTREE defaults to cwd, so it finds sources referenced from the .tmpl
file in current location. What didn't work is execution of
scripts/kernel-doc. This is now executed with KBUILD_SRC prepended,
which is what it should be.
