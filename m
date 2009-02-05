Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZBERvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZBERvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBERvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:51:41 -0500
Received: from smtp.nokia.com ([192.100.122.230]:31243 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbZBERvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:51:40 -0500
Date: Thu, 5 Feb 2009 19:38:10 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Kevin Hilman <khilman@deeprootsystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wim@iguana.be" <wim@iguana.be>
Subject: Re: [PATCH] watchdog: davinci: convert to ioremap() +
	io[read|write]
Message-ID: <20090205173810.GE10567@scadufax.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1233854782-3642-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233854782-3642-1-git-send-email-khilman@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 05 Feb 2009 17:51:32.0207 (UTC) FILETIME=[6140BFF0:01C987BA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 06:26:22PM +0100, Kevin Hilman wrote:
> +       wdt_base = ioremap(res->start, res->end);

second argument should be size right ??

ioremap(res->start, res->end - res->start + 1);

in fact you have a size variable in this driver used for
request_mem_region() just be sure the value is still valid and use it
;-)

> +       if (!wdt_base) {
> +               printk(KERN_ERR MODULE_NAME "failed to map memory region\n");

you have a dev pointer in platform_device would be cool
to use dev_err() here

-- 
balbi
