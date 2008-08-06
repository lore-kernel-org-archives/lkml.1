Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYHFSdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYHFSdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYHFSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:33:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:52456 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbYHFSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:33:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WgQDmRM2Br7+gxAjIy+Zep3USYrGpvq+ummTT2q5S1gkBFrlsFvDkTh4tojL0U2XQh
         2KTfljfbh6iswFu8WUven4CbSYcifXrzi8z1NUfZ8BLvlzHeJMFLhzv6fOHgGxxarRCf
         fuaDJJ7wgZgjQArTrSDJmOS2+xOt+itWPrlNQ=
Message-ID: <58cb370e0808061133l724dc70do834ddcbc128af442@mail.gmail.com>
Date: Wed, 6 Aug 2008 20:33:24 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/2] ide-{floppy,tape}: remove request stack
Cc: linux-kernel@vger.kernel.org, "Borislav Petkov" <petkovbb@gmail.com>
In-Reply-To: <200808061914.06361.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200808061914.06361.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 7:14 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:

[...]

> ---
> pc stack can also be removed with a bit of care, we just need sth like:
>
> - add request_sense_pc (request_sense_rq alike)
>
> - dynamically allocate pc-s for blk_{fs,pc}_request() in ide-floppy.c
>  and for REQ_IDETAPE_{READ,WRITE} in ide-tape.c
>
> - add PC_FLAG_DYN for dynamically allocated pc-s
>
> - (the difficult part) figure out where to put freeing of dynamic pc-s
>
> Borislav, AFAIR you had some patches doing dynamic pc/rq-s?
> Maybe it would be possible to dust off just their rq-parts?

Please disregard above comments -- I found a better way to deal with rq stack.
