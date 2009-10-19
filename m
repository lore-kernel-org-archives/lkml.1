Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZJSJQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZJSJQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZJSJQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:16:14 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36414 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZJSJQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:16:14 -0400
Date: Mon, 19 Oct 2009 11:16:17 +0200
From: Andreas Mohr <andi@lisas.de>
To: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org,
       Andreas Mohr <andi@lisas.de>
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
Message-ID: <20091019091617.GA13277@rhlx01.hs-esslingen.de>
References: <20091019102116.222ff9c3.peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019102116.222ff9c3.peter@piie.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 19, 2009 at 10:21:16AM +0200, Peter Feuerer wrote:
> 
> Hi Boris,
> 
> what do you think about this patch?

Personally I'm hurting a bit due to the open-coded "* 1000" transition
in all places.

I'd add a helper macro
#define TEMP_DEGREE_TO_SYS(x) ((x) * 1000)
and use that in all places where it matters.

Advantage:
- either no mistyping (10000 instead of 1000) _or_ bug occurring in _all_
  places where this macro is used
- easily grepped-for
- easily changed once the system granularity gets updated

Andreas Mohr
