Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYJCO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYJCO6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYJCO6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:58:22 -0400
Received: from gw-d.mimosa.com ([209.161.207.149]:55616 "EHLO gw-d.mimosa.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbYJCO6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:58:21 -0400
Date: Fri, 3 Oct 2008 10:57:41 -0400 (EDT)
From: "D. Hugh Redelmeier" <hugh@mimosa.com>
Reply-To: "D. Hugh Redelmeier" <hugh@mimosa.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
In-Reply-To: <48E5CBFC.3090702@zytor.com>
Message-ID: <alpine.LRH.2.00.0810031040410.4688@redclaw.mimosa.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com> <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com> <20081003003237.04469201@werewolf.home> <20081003073727.GC4950@elte.hu> <48E5CBFC.3090702@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1603562624-1223045862=:4688"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1603562624-1223045862=:4688
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

| From: H. Peter Anvin <hpa@zytor.com>

| Ingo Molnar wrote:
| > * J.A. Magallón <jamagallon@ono.com> wrote:

| > > +++ arch/x86/kernel/cpu/mtrr/if.c     2008-10-03 00:22:34.000000000 +0200
| > > @@ -16,7 +16,7 @@
| > >  static const char *const mtrr_strings[MTRR_NUM_TYPES] =
| > >  {
| > >      "uncachable",               /* 0 */
| > > -    "write-combining",          /* 1 */
| > > +    "write-combine",            /* 1 */
| > 
| > hm, maybe this bit could confuse versions of Xorg that modifies /proc/mtrr -
| > i.e. this could be part of the ABI towards user-space. We'll see.
| > 
| 
| This *IS* part of the ABI toward userspace, although I think Xorg uses the
| ioctl() interface.

My mtrr-uncover program uses this interface.

One reason is that the ioctl interface is broken.  See
http://lkml.org/lkml/2008/8/5/62

I too understand that Xorg drivers uses the ioctl interface.  Since
they only use it on video device buffers, and those buffers always
seem to start and end below 4GiB, the ioctl bugs probably don't affect
Xorg.

The ioctl bugs do mean that Xorg drivers cannot even see the MTRR
nesting problems let alone address them.

The ib_path driver apparently uses MTRRs in a way analogous to Xorg
drivers.  There is a script that is part of Fedora that uses the
/proc/mtrr interface to attempt to fix nested MTRRs:
  http://cvs.fedora.redhat.com/viewvc/devel/rdma/rdma-fixup-mtrr.awk

There may well be other users of this API.  Or is it an ABI.  I'm not sure.

It would be useful to know what code exists that uses the
MTRR-changing interfaces.  I only know about the ones I've mentioned
above.  Does anyone know of others?
--8323328-1603562624-1223045862=:4688--
