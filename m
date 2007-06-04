Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbXFDTB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbXFDTB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759980AbXFDTBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:01:05 -0400
Received: from gw.goop.org ([64.81.55.164]:48705 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759712AbXFDTBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:01:04 -0400
Message-ID: <46646164.3010406@goop.org>
Date: Mon, 04 Jun 2007 12:00:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org> <46644B99.1060304@zytor.com>
In-Reply-To: <46644B99.1060304@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> goto labels are scoped in one sense: they are only reachable from inside
> the block they are defined in, so I would disagree with this statement.
>   

Erm, no I think you're wrong there (or we're talking at cross
purposes).  They're visible to the whole function they're defined in,
regardless of what block scope happens to be current at the time.  You
need to use the gcc "__label__" extension to make a locally-scoped
label.  Otherwise this wouldn't work:

	if (a_failed)
		goto cleanup;
	[...]
	if (b_failed) {
cleanup:
		cleanup();
	}


    J
