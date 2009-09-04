Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbZIDSTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbZIDSTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933651AbZIDSTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:19:34 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:40930 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908AbZIDSTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:19:34 -0400
Date: Fri, 4 Sep 2009 20:19:39 +0200
From: Bastian Blank <waldi@debian.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, 544145@bugs.debian.org,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
Message-ID: <20090904181939.GA9077@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com, 544145@bugs.debian.org,
	Keir Fraser <keir.fraser@eu.citrix.com>
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org> <4AA03DE8.40706@goop.org> <20090903223603.GA19945@wavehammer.waldi.eu.org> <4AA13B4B.7020101@goop.org> <20090904174605.GA8396@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090904174605.GA8396@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 07:46:05PM +0200, Bastian Blank wrote:
> On Fri, Sep 04, 2009 at 09:07:39AM -0700, Jeremy Fitzhardinge wrote:
> > On 09/03/09 15:36, Bastian Blank wrote:
> > > This function looks weird. It tries to restores the user code segment.
> > > But the documentation from AMD explicitely stat that the CS and SS are
> > > restored from the STAR register.
> | #define FLAT_RING3_CS32 0xe023
> | wrmsr(MSR_STAR, 0, (FLAT_RING3_CS32<<16) | __HYPERVISOR_CS);
> But this does not match my observation either.

Well, it does. The values for a long-mode program within Xen:

| cs             0xe033   57395
| ss             0xe02b   57387

Values on the bare hardware:

| cs             0x33     51
| ss             0x2b     43

Values for a compatibility-mode program on the bare hardware:

| cs             0x23     35
| ss             0x2b     43

So Xen adds 0xe000 (no idea what that means), but the Linux kernel
expects the value without.  Long mode is not affected.

Okay, I tried the test program again and yes, it jumps back into
long-mode. (See the 0x10 in the restored CS[1].)

| cs             0xe033   57395
| ss             0xe02b   57387

Bastian

[1]: http://amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf,
     page 151
-- 
Where there's no emotion, there's no motive for violence.
		-- Spock, "Dagger of the Mind", stardate 2715.1
