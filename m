Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbXHBUAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbXHBUAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759049AbXHBT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:59:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54309 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758976AbXHBT74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:59:56 -0400
Date: Thu, 2 Aug 2007 21:59:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
Message-ID: <Pine.LNX.4.64.0708022157310.9319@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 21:55, Guennadi Liakhovetski wrote:
>Hi
>
>I've run across the following gcc "feature":
>
>	char c[4] = "01234";
>
>gcc emits a nice warning
>
>warning: initializer-string for array of chars is too long
>
>But do a
>
>	char c[4] = "0123";
>
>and - a wonder - no warning. No warning with gcc 3.3.2, 3.3.5, 3.4.5, 
>4.1.2. I was told 4.2.x does produce a warning. Now do a
>
>	struct {
>		char c[4];
>		int i;
>	} t;
>	t.i = 0x12345678;
>	strcpy(t.c, c);
>
>and t.i is silently corrupted. Just wanted to ask if this is known, 
>really...

What does this have to do with the kernel? The string "0123" is
generally _five_ characters long, so c[4] is not enough.
Or use strncpy.



	Jan
-- 
