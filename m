Return-Path: <linux-kernel-owner+w=401wt.eu-S1764968AbYEFPnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764968AbYEFPnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760697AbYEFPnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:43:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbYEFPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:43:00 -0400
Date: Tue, 6 May 2008 12:42:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Cc: "v4l-dvb maintainer list" <v4l-dvb-maintainer@linuxtv.org>,
       linuxtv-commits@linuxtv.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix FW_LOADER depencency at
 v4l/dvb
Message-ID: <20080506124223.653c37f2@gaivota>
In-Reply-To: <37219a840805060754j3c65d812l527d1837a5d95266@mail.gmail.com>
References: <E1JtNrl-0006mQ-MG@www.linuxtv.org>
	<37219a840805060754j3c65d812l527d1837a5d95266@mail.gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 10:54:02 -0400
"Michael Krufky" <mkrufky@linuxtv.org> wrote:

> Mauro,
> 
> I disagree with this change.

So, propose another way to fix. Without this patch, if HOTPLUG = 'n', several
drivers will break.

Sorry, but I can't see any other solution (in fact, I tested "select HOTPLUG",
but this caused circular dependencies loops). 

The way "select" works is simple: You need to manually add all "depends on"
from the original symbol into the one that adds "select". I don't like this way
(and I'm currently questioning this at LKML), but while people don't decide to
implement "select" on another way (or to write a different tag for this, as
proposed by Sam), the proper fix is the one I've proposed.

If you have a better proposal, please, feel free to send it. If you have a
better fix, I'll revert this one.

> It looks like you are attempting to workaround a Kbuild bug

It is not a Kbuild bug, but the way Kbuild were implemented. This is what is
written at kbuild/kconfig-language.txt:

"       select should be used with care. select will force
        a symbol to a value without visiting the dependencies.
        By abusing select you are able to select a symbol FOO even
        if FOO depends on BAR that is not set.
        In general use select only for non-visible symbols
        (no prompts anywhere) and for symbols with no dependencies.
        That will limit the usefulness but on the other hand avoid
        the illegal configurations all over.
        kconfig should one day warn about such things." 

Cheers,
Mauro
