Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXKFRKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXKFRKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXKFRKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:10:25 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33113 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXKFRKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:10:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
	<472F5941.2060507@zytor.com>
	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
	<472F61C8.4040300@zytor.com>
	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>
	<m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>
	<472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org>
	<472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org>
	<472FBF40.1010300@zytor.com> <472FC0F3.10102@goop.org>
	<472FC401.9020202@zytor.com> <47309389.3080403@goop.org>
	<47309608.9030200@zytor.com> <47309C85.6030904@goop.org>
	<47309D98.8080003@zytor.com>
Date: Tue, 06 Nov 2007 10:09:23 -0700
In-Reply-To: <47309D98.8080003@zytor.com> (H. Peter Anvin's message of "Tue,
	06 Nov 2007 09:00:08 -0800")
Message-ID: <m1zlxr5mik.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> .notes : {
>>>     *(.note.*)
>>>     . = ALIGN(4);
>>>     LONG(0);
>>>     LONG(0);
>>>     LONG(0);
>>> }
>>>
>>> Am I missing something?
>>
>> Oh, I suppose, but I never much liked putting data-definition into the
>> linker script.
>>
>
> I think it should be sparsely used, but stuff like simple end markers is pretty
> much what it's good for.
>
> The main reason I want to avoid adding another header field is that the header
> is a finite resource; one of the many poor decisions in its original design was
> using a 2-byte jump at the top, so address 0x281 is the end of the universe.

That was fixed long ago (by having a 4 byte reserved field in the middle) that
we can do a two byte jump and then do a farther jump from there to the 16bit
code.  So as long as we actually use discipline and really reserve
the field for a further jump there should be no need for 0x281 being the end
of the universe.

Eric
