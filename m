Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbXKFQRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbXKFQRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXKFQRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:17:41 -0500
Received: from gw.goop.org ([64.81.55.164]:56266 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbXKFQRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:17:40 -0500
Message-ID: <47309389.3080403@goop.org>
Date: Tue, 06 Nov 2007 08:17:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org> <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com> <472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org> <472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org> <472FBF40.1010300@zytor.com> <472FC0F3.10102@goop.org> <472FC401.9020202@zytor.com>
In-Reply-To: <472FC401.9020202@zytor.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> The ELF note format is sane enough, although it looks like it's not
> self-terminating, so we'd either need an offset and a length field, or
> adopt the convention that namesz = descsz = type = 0 terminates the
> block (I prefer the latter, myself.)

Hm, I think offset+length would be better: it's how they're represented
in a normal ELF file, so you can just extract the length if you're
extracting the notes.  Also, generating a terminating note with the
current linker-based notes machinery would be a bit of a pain.

    J
