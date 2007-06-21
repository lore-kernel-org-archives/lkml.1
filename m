Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXFULI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXFULI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXFULIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:08:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59015 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbXFULIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:08:48 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: JIT emulator needs
To: Albert Cahalan <acahalan@gmail.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 21 Jun 2007 13:08:36 +0200
References: <8tGiE-2Hv-1@gated-at.bofh.it> <8xNvm-2Tw-29@gated-at.bofh.it> <8xYTM-3So-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I1KWi-0000nV-8s@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18IURlR7KxJwthUZHhxB2tl3Avlh4bHK3+g41g
 22pfLhA85MYF5dqXfLCb8y3OCfpTp47FFFV30fFsYqqDKqrRFp
 xkM6VaAYIL4QF2y8WxWVA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan <acahalan@gmail.com> wrote:
> On 6/19/07, William Lee Irwin III <wli@holomorphy.com> wrote:
>> On Fri, Jun 08, 2007 at 02:35:22AM -0400, Albert Cahalan wrote:

>>> Right now, Linux isn't all that friendly to JIT emulators.
>>> Here are the problems and suggestions to improve the situation.
>>> There is an SE Linux execmem restriction that enforces W^X.
>>> Assuming you don't wish to just disable SE Linux, there are
>>> two ugly ways around the problem. You can mmap a file twice,
>>> or you can abuse SysV shared memory. The mmap method requires
>>> that you know of a filesystem mounted rw,exec where you can
>>> write a very large temporary file. This arbitrary filesystem,
>>> rather than swap space, will be the backing store. The SysV
>>> shared memory method requires an undocumented flag and is
>>> subject to some annoying size limits. Both methods create
>>> objects that will fail to be deleted if the program dies
>>> before marking the objects for deletion.
>>
>> If the policy forbidding self-modifying code lacks a method of
>> exempting programs such as JIT interpreters (which I doubt) then
>> it's a problem. I'm with Alan on this one.
> 
> It does and it doesn't. There is not a reasonable way for a
> user to mark an app as needing full self-modifying ability.
> It's not like the executable stack, which can be set via the
> ELF note markings on the executable. (ELF note markings are
> ideal because they can not be used via a ret-to-libc attack)
> 
> With admin privs, one can change SE Linux settings. Mark the
> executable, disable the protection system-wide, generate a
> completely new SE Linux policy, or just turn SE Linux off.

According to the documents I found about SELinux, you can also
 - create a this-app-needs-selfmodification type
 - allow users to change the context type of their files to this type
 - configure a domain to allow self-modification
 - configure the domain transition

Brave words from someone who did not yet successfully find the magic in
order to install the refpolicy on debilian (after finding their refpolicy-foo
to be incomplete and their refpolicy-src to not compile).
-- 
Why do women have smaller feet than men?
It's one of those "evolutionary things" that allows them to stand
closer to the kitchen sink.
Friﬂ, Spammer: Jy@jRwxq.7eggert.dyndns.org d-afnhbe@p9J.7eggert.dyndns.org
