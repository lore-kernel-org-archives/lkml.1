Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYHSVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYHSVqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYHSVqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:46:12 -0400
Received: from main.gmane.org ([80.91.229.2]:35448 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYHSVqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:46:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH 0/0] Power domain and clock domain patches for omap
Date: Tue, 19 Aug 2008 21:46:00 +0000 (UTC)
Message-ID: <g8feuo$i9$1@ger.gmane.org>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ppp89-110-31-4.pppoe.avangarddsl.ru
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Lindgren wrote:

> Hi all,
> 
> This patch series contains power domain and clock domain specific
> patches for omap posted to linux-arm-kernel list during 2.6.25-rc5.
> 
> I'm reposting the series to a wider audience as Russell King suspected
> that other archs may be interested in reviewing these too, or at least
> some parts of the code.
> 
> Please take a look and comment the code. Also please point out the
> pieces of code that may be suitable for your arch too!

There is one major flaw IMO in this code. Please correct me if I'm wrong:
Driver A: powerdomain_register()
Driver B: powerdomain_get()
Driver A: powerdomain_unregister()

Then Driver B has a reference to unregistered domain. And as powerdomains
lack any type of refcounting this can lead to any type of memory access
bugs if Driver A is unloaded from the kernel.

-- 
With best wishes
Dmitry


