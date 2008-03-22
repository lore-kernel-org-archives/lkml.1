Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYCVMzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYCVMzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 08:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYCVMzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 08:55:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17366 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbYCVMzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 08:55:46 -0400
Date: Sat, 22 Mar 2008 13:55:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] cdrom: use list_head for cdrom_device_info list
Message-ID: <20080322125535.GE15355@kernel.dk>
References: <20080322030948.GA3665@APFDCB5C> <20080322031047.GB3665@APFDCB5C> <20080322031204.GC3665@APFDCB5C> <20080322031248.GD3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322031248.GD3665@APFDCB5C>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22 2008, Akinobu Mita wrote:
> Use list_head for cdrom_device_info list instead of opencoded
> singly list handling.

Looks good, but you don't seem to be initializing ->list anywhere. Did
you test this?

I'd suggest just adding an INIT_LIST_HEAD() before the list_add() in
register_cdrom()

You also seem to remove the !cdi check, which would be an unrelated
change.

-- 
Jens Axboe

