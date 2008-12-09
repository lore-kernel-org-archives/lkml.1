Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYLILDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYLILDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLILDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:03:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54038 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYLILDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:03:37 -0500
Date: Tue, 9 Dec 2008 12:15:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: x86-64: __pa_symbol() vs. __pa()
Message-ID: <20081209111508.GB23556@one.firstfloor.org>
References: <493E50DE.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493E50DE.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 10:05:02AM +0000, Jan Beulich wrote:
> Can any of you recall the reason for the comment accompanying the
> __pa_symbol() definition:
> 
> /* __pa_symbol should be used for C visible symbols.
>    This seems to be the official gcc blessed way to do such arithmetic. */

gcc assumes that such symbol arithmetic doesn't wrap. iirc there was a 
miscompilation on PPC64 because of that and then it was fixed
everywhere. On x86-64 there are normally no wraps, but there might
be in some cases.

-Andi
