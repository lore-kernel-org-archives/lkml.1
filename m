Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbYD3Weo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbYD3Weo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbYD3Wed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:34:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:15961 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbYD3Web (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mmgKYhXQkHJfia7Km+D1HXJj3Kz3lwVOtVb0OXY6Ot8rzcNMWrShBne6sGnYipHRk9diHZ2DgmaLSbaxwHCZIsjSfAr6HCOszegxJ8L/7TAsLYY8ojHpZuaI62qgg6P9o8L5KKGwaolFc0Ta6npnSbdhuNcULV2DU454NyeX80k=
Subject: Re: [PATCH 02/10] scsi: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <1209594551.3774.37.camel@localhost.localdomain>
References: <1209593020.24729.112.camel@brick>
	 <1209594551.3774.37.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:34:48 -0700
Message-Id: <1209594888.24729.130.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-30 at 17:29 -0500, James Bottomley wrote:
> On Wed, 2008-04-30 at 15:03 -0700, Harvey Harrison wrote:
> > drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
> > drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
> > drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer

> The flashpoint initialiser changes look wrong:  {0} is a conventional
> notation for zero initialise this structure.  Sparse should probably be
> taught to recognise that.

Actually, looking closer, should this be initialized at all?  Can we
just remove the initialization here and let them end up in .bss?

Harvey

