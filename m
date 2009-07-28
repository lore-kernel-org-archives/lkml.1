Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZG1NkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZG1NkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 09:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG1NkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 09:40:11 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:43264 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZG1NkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 09:40:10 -0400
Message-ID: <4A6EFFAF.10603@mnementh.co.uk>
Date: Tue, 28 Jul 2009 14:39:59 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> If the platform device has a clock associated with the tmio-mmc device, 
> use it.

As RMK has stated manny times before now, you cannot pass struct clks to 
devices like this, they should be claimed using the clk api.

The problem for tmio-mmc is that the struct clk is tied to the 
architecture code, so at present we cant create new clk providers. What 
we need is for the clk api to be divorced from the arch code so that the 
TMIO MFD driver can create its own clocks that can be claimed by its 
children.
