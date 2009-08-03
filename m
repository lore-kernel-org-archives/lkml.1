Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZHCQUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZHCQUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZHCQUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:20:43 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:56378 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbZHCQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:20:43 -0400
From: Frans Pop <elendil@planet.nl>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: [PATCH] Switch atmel_serial to dev_pm_ops
Date: Mon, 3 Aug 2009 18:20:41 +0200
User-Agent: KMail/1.9.9
Cc: haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org
References: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com> <20090803170947.2f199b93@hskinnemoen-d830> <20090803170947.2f199b93@hskinnemoen-d830> <20090803155049.GD5002@laptop>
In-reply-To: <20090803155049.GD5002@laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031820.42760.elendil@planet.nl>
X-OriginalArrivalTime: 03 Aug 2009 16:20:43.0294 (UTC) FILETIME=[5963DBE0:01CA1456]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre wrote:
>> Why not
> 
>> #define atmel_serial_pm_ops   NULL
> 
> Because the .pm field is set to the address of atmel_serial_pm_ops, and
> iirc taking the address of NULL is not allowed.

The following construction is possible however (first used by Magnus Damm 
for some of the SuperH drivers):

#ifdef CONFIG_PM
[...]
#define DRIVER_PM_OPS (&driver_pm_ops)
#else
#define DRIVER_PM_OPS NULL
#endif

...
      .driver = {
...
             .pm = DRIVER_PM_OPS,
      }
...

Cheers,
FJP
