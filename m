Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbYCFLnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbYCFLnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbYCFLmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:42:53 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37050 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbYCFLmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:42:53 -0500
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: =?ISO-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47CFD6B0.4020602@draigBrady.com>
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
	 <47CFD6B0.4020602@draigBrady.com>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Thu, 06 Mar 2008 12:45:14 +0100
Message-Id: <1204803914.4325.16.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le jeudi 06 mars 2008 à 11:34 +0000, Pádraig Brady a écrit :
> Laurent Vivier wrote:
> > This patch allows to use loop device with partitionned disk image.
> > 
> > Original behavior of loop is not modified.
> > 
> > A new parameter is introduced to define how many partition we want to be
> > able to manage per loop device. This parameter is "max_part".
> 
> I like it!

Thanks,

> Shouldn't we set max_part to non zero by default though?

Well, the problem is that you modify the default minor number of loop
device if max_part != 0, so I'm afraid of compatibility problems:
with max_part=0, loop0 is minor 0, loop1 is minor 1,
with max_part=63, loop0 is minor 0, loop1 is minor 64, whereas loop0p1
is minor 1.

> Hopefully I can throw away my loopback partition mounting script soon :)
> http://www.pixelbeat.org/scripts/lomount.sh
> 
> cheers,
> Pádraig.
> 

Regards,
Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

