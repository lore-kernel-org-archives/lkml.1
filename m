Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYKHPgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYKHPgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 10:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYKHPgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 10:36:15 -0500
Received: from genesysrack.ru ([195.178.208.66]:43728 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbYKHPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 10:36:14 -0500
Date: Sat, 8 Nov 2008 18:35:45 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org
Subject: Re: [1/1] Use pid in inotify events.
Message-ID: <20081108153545.GA3859@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael.

On Sat, Nov 08, 2008 at 09:25:16AM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
> I've not looked closely at the patch, but a quick question.  The
> ookied field is unused for _most_ events, but is used for rename
> events.  Are you saying that with this patch, that the cookie will be
> used as before for rename events, but for other events it will be the
> PID of the triggering process?  If so, that seems a bit ugly -- why
> wouldn't we also be intersted in the PID for rename events?

Yes, rename events actually consist of at least two: move from and move
to, and they carry the same cookie, so that userspace could combine them
into single transaction. All others use zero, so I decided to put PID of
the caller there. This does not look perfect of course, but we can not
change the structure layout, so rename events can not be changed to
carry additional PID field.

-- 
	Evgeniy Polyakov
