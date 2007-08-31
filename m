Return-Path: <linux-kernel-owner+w=401wt.eu-S965931AbXHaRaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965931AbXHaRaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965423AbXHaRaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:30:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41347 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759765AbXHaRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:30:13 -0400
Date: Fri, 31 Aug 2007 10:28:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@kernel-bugs.osdl.org
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
Message-ID: <20070831102858.74ec512f@laptopd505.fenrus.org>
In-Reply-To: <116718.45429.qm@web52005.mail.re2.yahoo.com>
References: <116718.45429.qm@web52005.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007 10:14:27 -0700 (PDT)
Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

> It seems to me that kernel/module.c allows the whole kernel to use
> exported symbols during the execution of the init function if they
> are weak: /* Ok if weak.  */ if (ELF_ST_BIND(sym[i].st_info) ==
> STB_WEAK) break;
> That seems a possible way to produce the scenario of this so-called
> bug.

if you export weak symbols in your own module AND you have some
piece of kernel that will start using the symbol (which means the
kernel already needs to know about it) AND you don't know what you're
doing you get shot in the foot... BFD

maybe if you have such a case you should publish the source code of
that case so that we can suggest alternative approaches of what you're
trying to do..
