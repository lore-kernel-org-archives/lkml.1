Return-Path: <linux-kernel-owner+w=401wt.eu-S1764237AbYEOSXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764237AbYEOSXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbYEOSXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:23:34 -0400
Received: from mail.aknet.ru ([78.158.192.26]:58216 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbYEOSXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:23:34 -0400
Message-ID: <482C7F8A.4000606@aknet.ru>
Date: Thu, 15 May 2008 22:23:06 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roberto Oppedisano <roberto.oppedisano@infracom.it>
Subject: Re: [Bug #10679] 2.6.26-rc1 regression:	e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
 breaks artsd
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>	<88YBFoyd1CN.A._sF.Ov1JIB@chimera>	<s5hskwmeb1h.wl%tiwai@suse.de>	<20080514212011.GH7054@mit.edu>	<s5hhcd0azv1.wl%tiwai@suse.de>	<20080515130654.GC18825@mit.edu> <s5h8wybr0c2.wl%tiwai@suse.de>
In-Reply-To: <s5h8wybr0c2.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
>> anything entertaining at all.  Any attempts to use it on my system
>> just lead to various confusing error messages.
> It looks like a problem in the recent alsa-lib.
It is actually a problem in a non-recent
alsa-lib. With alsa-lib from hg it works
fine, but breaks with 1.0.16.
The commit that introduced an incompatibility
is this one:
http://hg-mirror.alsa-project.org/alsa-kernel/diff/26b0243ab4fa/drivers/pcsp/pcsp_lib.c
I certainly was not considering the
maintenance problems it creates. :(
Perhaps should we revert this commit
for now, and reintroduce after the
next alsa-lib release?

FYI, the alsa-lib fix is this one:
http://hg-mirror.alsa-project.org/alsa-lib/diff/8a980469cd71/src/conf/cards/PC-Speaker.conf

The problem happened because the
softvol plugin doesn't support 8bit
formats. So the above config change
was needed.
