Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZHKUHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZHKUHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZHKUHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:07:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:45693 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZHKUHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:07:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kEo5wBFgkBqGkznbM9lh0bL56AcHl9VzXgmwIrT7AiyGrxrlGLmgFk08qxZeepSylQ
         OsL2uQM4R2MLo8u/T7VHiz63exER30OdgMN/vBXDyXGMEUM96NbCnwCc9ROSj6N4DbHK
         9ooYzK/nKtqZunuYW5/Fg+v6ZYfasp6eBNrgM=
Date: Wed, 12 Aug 2009 00:07:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: npiggin@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
Message-ID: <20090811200711.GA24213@lenovo>
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811111607.310739140@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[npiggin@suse.de - Tue, Aug 11, 2009 at 09:09:06PM +1000]
...
| +static void update_queue_simple(struct sem_array *sma, ushort semnum)
| +{
| +	if (unlikely(sma->complex_count)) {
| +		update_queue(sma);
| +	} else {
| +		struct sem *sem;
| +
| +		sem = &sma->sem_base[semnum];
| +		if (sem->semval > 0)
| +			update_negv_queue(sma, sem);
| +		if (sem->semval == 0)
| +			update_zero_queue(sma, sem);
| +	}
| +}
| +
...

Hi Nick,

mostly probably miss something but can't we trgigger BUG_ON at updating
zero queue if semaphore was created with undo list and via new operation
reached -ERANGE on undo value?

Again, I could be missing something or plain wrong. Just a thought.

	-- Cyrill
