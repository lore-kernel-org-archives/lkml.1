Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbYKLQIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbYKLQIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYKLQIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:08:04 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:11052 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKLQIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:08:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dmZohrZkoKN9YheViloRzlCtJee9kmVAUc2yDrS0URUtRGYG9hluLOzUkFAQ9QlrYl
         wjWstYJsca6respeLXMEUWxVeDFBeehOPYZpoVvFu/KdemOjwCiHkOswcB5cfs5b5lOO
         Y52JXaEvDx7ewSjfGPCxzjKH0np0vhpvcCszA=
Message-ID: <8bd0f97a0811120808p5858d5adleeef43b1d374bee1@mail.gmail.com>
Date: Wed, 12 Nov 2008 11:08:00 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] physmap: Fix leak of memory returned by parse_mtd_partitions
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081113.005534.56563769.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
	 <20081113.005534.56563769.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 10:55, Atsushi Nemoto wrote:
> On Wed, 12 Nov 2008 23:57:33 +0900 (JST), Atsushi Nemoto wrote:
>> The mtd partition parser returns an allocated pointer array of
>> mtd_partition.  The caller must free it.  The array is used only for
>> add_mtd_partitions(), so free it just after the call.
>>
>> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
>> ---
>>  drivers/mtd/maps/physmap.c |   17 ++++++++---------
>>  1 files changed, 8 insertions(+), 9 deletions(-)
>
> And many other callers of parse_mtd_partitions() also do not free the
> returned memory.  With a quick look, 21 of 36 have same defect.

i wonder why we duplicate this same code block in so many places.  and
why does every driver have to declare its own list of parsers ?  cant
we unify all of these in one place ?

> drivers/mtd/maps/bfin-async-flash.c

i can fix this one if no one else gets to it
-mikex
