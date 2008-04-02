Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbYDBTWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbYDBTWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757578AbYDBTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:21:51 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:62490 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbYDBTVt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:21:49 -0400
Date: Wed, 2 Apr 2008 20:21:40 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: linux-kernel@vger.kernel.org
Subject: git problem
Message-ID: <20080402192140.GA5951@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I seem to be doing something wrong.  I'm trying to bisect to
discover which commit causes my failure to shut down or restart from
gdm on one box (the gdm window disappears, but the background
remains instead of falling back to a console and shutting down).

 So far, I've discovered that the problem is slightly intermittent,
so I'm not labelling a kernel good until it successfully restarts or
shuts down 10 times (indications are that a bad version will fail in
the first 3 attempts).

 Anyway, I've confirmed my supposition that 2.6.24 was good in this
respect, and that 2.6.25-rc1 was bad.  After about a day of
bisection / archive / build /test I went to set an extraversion in
the Makefile (everything had been labelled 2.6.24 because this was
before rc1), and discovered it was already labelled as 2.6.24-rc4,
i.e. far too early.

 Reset, repeated, git came up with the same commits (I wondered if
I'd mispasted at some point).  Looked at the log, this seemed to be
the newest thing available.  Reset, looked at the full log, but I'm
out of my depth trying to understand this.

FWIW, these were the commits it told me to test:
[1c17f4d615f34a4ecfcf9132d643126b226f5e79] x86: ioremap_nocache fix
good

[d2fc0bacd5c438cb459fdf531eff00ab18422a00] Merge git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86
bad

[7c0141591fcf92ddc96a4ee04e35783a15bd68c8] [ALSA] virtuoso: monitor external power on D2X
good

[b6cf160c4b788a31f6a4017a469b956ca77febf4] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
bad

[5de8b3acda2d03f8aeb21b5a267645088718c356] USB: CP2101 New Device IDs
bad - dated 3rd Jan, but I think it was merged in the right timeframe

[f776c4cda449bab463f5388eb07bd63dc52e2b13] [NETFILTER]: ebtables: Update modules' descriptions
bad

[e78c9d285709f535caae405f1da5b2936f51f0b5] b43legacy: fix MAC control and microcode init
bad

[e1a9c9872dd004617555dff079b357a6ffd945e9] Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/perex/alsa
good

[294d5cc233d81ec4aec77ebc60dc5752a3d0082a] Add schedule_timeout_killable
 - This appears to date from 6th December, and to have been merged
around then.

Confused.  Help ?  Please ?

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
