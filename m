Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbXKFRF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbXKFRF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 12:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbXKFRFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 12:05:49 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38793 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXKFRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 12:05:48 -0500
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
	<47309608.9030200@zytor.com>
Date: Tue, 06 Nov 2007 10:04:13 -0700
In-Reply-To: <47309608.9030200@zytor.com> (H. Peter Anvin's message of "Tue,
	06 Nov 2007 08:27:52 -0800")
Message-ID: <m1640f71bm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> The ELF note format is sane enough, although it looks like it's not
>>> self-terminating, so we'd either need an offset and a length field, or
>>> adopt the convention that namesz = descsz = type = 0 terminates the
>>> block (I prefer the latter, myself.)
>>
>> Hm, I think offset+length would be better: it's how they're represented
>> in a normal ELF file, so you can just extract the length if you're
>> extracting the notes.  Also, generating a terminating note with the
>> current linker-based notes machinery would be a bit of a pain.
>
> .notes : {
> 	*(.note.*)
> 	. = ALIGN(4);
> 	LONG(0);
> 	LONG(0);
> 	LONG(0);
> }
>
> Am I missing something?

I don't think adding a length any harder.

The all zero note is reserved so using it this way should be ok.
Regardless this sounds like a sane thing to be looking at.

Eric
