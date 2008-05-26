Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbYEZI6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbYEZI6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYEZI60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:58:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60220 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYEZI6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:58:25 -0400
Subject: Re: [PATCHv3 27/28] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       johannes@sipsolutions.net
In-Reply-To: <1211734802.31212.129.camel@shinybook.infradead.org>
References: <1211708969@pmac.infradead.org>
	 <E1K0DOP-0007EW-F0@shinybook.infradead.org>
	 <1211734802.31212.129.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Mon, 26 May 2008 09:58:20 +0100
Message-Id: <1211792300.23085.1.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-25 at 18:00 +0100, David Woodhouse wrote:
> Still don't have the behaviour we want from clean/mrproper, but I think
> we need Sam's help with that.

I worked it out -- we don't include .config when we make clean, although
it was trying to remove the .S files corresponding to all the configured
firmwares, there were effectively none of those. Fixed thus:

-targets := $(firmware_objs) $(patsubst $(obj)/%,%, $(firmware_srcs))
+targets := $(patsubst $(obj)/%,%, $(wildcard $(shell find $(obj) -name \*.S)))

-- 
dwmw2

