Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbXKFBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbXKFBMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXKFBME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:12:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbXKFBMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:12:01 -0500
Message-ID: <472FBF40.1010300@zytor.com>
Date: Mon, 05 Nov 2007 17:11:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org> <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com> <472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org> <472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org>
In-Reply-To: <472FBC83.5060509@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>> I'm not so sure about that.  Xen PV is rather fundamentally a
>> different beast, hence the platform field recently added to the protocol.
> 
> Hm, OK.  So make this predicated on "hardware subarchitecture == PC".

Yes; specifically, boot_params.hdr.hardware_subarch == 0 (as opposed to 
compile-time subarchitectures, like Voyager, which still boots the same 
way as far as I know.)

It would definitely be good to document what other values in this field 
changes, of course.

>> This is addressed by the "don't reload segments" bit in LOADFLAGS.
> 
> OK.

Specifically, with this bit set the decompression code won't touch the 
segment registers at all, and it's up to the caller to have all code and 
data segments set up with suitable descriptors.  The kernel will still 
try to install its own GDT when the kernel proper starts; this becomes a 
hardware_subarch issue.

	-hpa
