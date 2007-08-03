Return-Path: <linux-kernel-owner+w=401wt.eu-S1761821AbXHCIAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761821AbXHCIAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbXHCIAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:00:01 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36919 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516AbXHCIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:00:01 -0400
Date: Fri, 3 Aug 2007 09:59:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Satyam Sharma <satyam@infradead.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Introduce strtol_check_range()
In-Reply-To: <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0708030958450.495@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707312203150.28746@enigma.security.iitk.ac.in>
 <20070801053509.GA5905@martell.zuzino.mipt.ru>
 <alpine.LFD.0.999.0708020454440.8258@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 05:16, Satyam Sharma wrote:
>
>BSD's strtonum(3) is a detestful, horrible shame.
>
>The strtol_check_range() I implemented here does _all_ that strtonum()
>does, plus is generic w.r.t. base, and minus the tasteless "errstr"
>argument.
>
>Tell me, how does that "errstr" ever make sense? We _anyway_ return
>errors (-EINVAL or -ERANGE) if any of those cases show up.

errstr (well, at least for strtol) are useful to find the first character that
does not make up a number (and then do whatever the user wants to, including,
continuing to parse). For example "chown 0:1337", strtol on "0:1337" should
give errstr=pointer to the ":", then check for it being a ':', then you know
the next char is the GID. :)


	Jan
-- 
