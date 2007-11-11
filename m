Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbXKKChl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbXKKChl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 21:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXKKChe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 21:37:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbXKKChd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 21:37:33 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC 13/13] Char: nozomi, cleanup read and write
Date: Sun, 11 Nov 2007 03:37:28 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jiri Slaby <jirislaby@gmail.com>, Adrian Bunk <bunk@kernel.org>
References: <10551261882075921134.slaby@pripojeni.net> <20071110161511.GA21669@stusta.de> <47362AF9.5080009@gmail.com>
In-Reply-To: <47362AF9.5080009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711110337.29831.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 23:04:41, you (Jiri Slaby) wrote:
> On 11/10/2007 05:15 PM, Adrian Bunk wrote:
> > On Fri, Nov 09, 2007 at 06:51:35PM -0500, Jiri Slaby wrote:
> >> ...
> >> -		if (size_bytes - i == 2) {
> >> +		if (unlikely(size_bytes - i == 2)) {
> >> ...
> > 
> > Please don't add likely/unlikely in drivers unless it brings a 
> > measurable improvement.
> Why? Anyway I think this is the case. The body of the then branch is executed at
> most once, while the else branch each time but last. If you write/read 1002
> bytes, it means 250:1. ...and it's invoked from interrupt too...

I just did some measurements of how often (under real life scenarios like
downloading big files, websurfing, chat and ssh sessions) those pathes are
used.

While in the read_mem32 the unlikekly really seems to be of no use at all (the
switch-case ahead seems to be hit nearly always), the unlikely in the 
write_mem32 seems to be fine.
I compared after each 30 seconds and got median ratio of 1381:1 (for the
likely path) after about 20 minutes, i see a range between 1046:1 and
3511:1. So i wouldn't call it a bad guess from my beginners point of view.

Thanks,
Frank

