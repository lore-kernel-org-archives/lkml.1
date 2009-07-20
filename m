Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZGTL77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZGTL77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbZGTL76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:59:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:43222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbZGTL76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:59:58 -0400
Subject: Re: [PATCH] kbuild: save ARCH & CROSS_COMPILE when building a
 kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090720115134.GA6517@merkur.ravnborg.org>
References: <20090720100157.GA6467@merkur.ravnborg.org>
	 <1248086059.15751.8405.camel@twins>
	 <20090720115134.GA6517@merkur.ravnborg.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 14:00:43 +0200
Message-Id: <1248091243.15751.8550.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 13:51 +0200, Sam Ravnborg wrote:
> -if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
> -if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi
> +for INSTALL in ~/bin/${CROSS_COMPILE} /sbin/${CROSS_COMPILE} ~/bin /sbin/; do
> +       if [ -x ${INSTALL}installkernel ]; then
> +               exec ${INSTALL}installkernel "$@"
> +       fi
> +done

Won't that still get upset if CROSS_COMPILE has whitespace in it, which
would form weird filenames etc.. or worse, it might match ~/bin/distcc
