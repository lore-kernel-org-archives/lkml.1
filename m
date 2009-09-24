Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZIXTkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZIXTkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbZIXTkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:40:08 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:54936 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbZIXTkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:40:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Alexander Huemer <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
Date: Thu, 24 Sep 2009 21:40:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <4ABBB8C2.2080901@sbg.ac.at> <200909242124.42187.elendil@planet.nl>
In-Reply-To: <200909242124.42187.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909242140.10174.elendil@planet.nl>
X-OriginalArrivalTime: 24 Sep 2009 19:40:10.0474 (UTC) FILETIME=[D3DD9CA0:01CA3D4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 September 2009, Frans Pop wrote:
> > error message from .31:
> >  [157152.418524] irq 23: nobody cared
>
> If no others reply and the issue can be reproduced reliably, running a
> git bisect between v2.6.29 and v2.6.30 to trace the cause of the
> regression could be an option.

Looking at the changes in drivers/ata/ahci.c, it might be worth to try if 
reverting the following commit fixes the issue:

commit a5bfc4714b3f01365aef89a92673f2ceb1ccf246
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Jan 23 11:31:39 2009 +0900

    ahci: drop intx manipulation on msi enable

It's a bit of a wild guess though.
