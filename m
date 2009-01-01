Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZAADnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZAADnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 22:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZAADnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 22:43:03 -0500
Received: from ozlabs.org ([203.10.76.45]:45991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbZAADnB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 22:43:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Yinghai Lu" <yinghai@kernel.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: parsing mem=700M broken
Date: Thu, 1 Jan 2009 14:12:56 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Paul Mackerras" <paulus@samba.org>,
       "Benjamin Herrenschmidt" <benh@au1.ibm.com>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <Pine.LNX.4.64.0812280033070.24494@blonde.anvils> <86802c440812271807q3decd21i5da99754d708449d@mail.gmail.com>
In-Reply-To: <86802c440812271807q3decd21i5da99754d708449d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901011412.57707.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 December 2008 12:37:59 Yinghai Lu wrote:
> On Sat, Dec 27, 2008 at 4:43 PM, Hugh Dickins <hugh@veritas.com> wrote:
> > I have to wonder if all this comes too late in the cycle for 2.6.29:
> > changing the early param handling of all the arches is difficult,
> > and apparently hasn't been much tested in the short time that it's
> > been out there in linux-next.  But of course, not for me to decide.
> 
> should be ok, just need to go over all early_param()

Yes, and understanding the intricacies of all 20+ archs boot code.
For example, I've just noticed that MIPS sets up the command line
in prom_init, called from setup_arch, so I've broken that entirely.

git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git

This is not going to make this merge window: I need to audit each arch
more deeply, then get help testing.

Thanks,
Rusty.
