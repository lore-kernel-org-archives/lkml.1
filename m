Return-Path: <linux-kernel-owner+w=401wt.eu-S932671AbZJ1ILT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbZJ1ILT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbZJ1ILS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:11:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55633
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620AbZJ1ILR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:11:17 -0400
Date: Wed, 28 Oct 2009 01:11:41 -0700 (PDT)
Message-Id: <20091028.011141.267473962.davem@davemloft.net>
To: andi@firstfloor.org
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091028075908.GO7744@basil.fritz.box>
References: <20091027.230450.222178419.davem@davemloft.net>
	<20091028.005342.60092591.davem@davemloft.net>
	<20091028075908.GO7744@basil.fritz.box>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 28 Oct 2009 08:59:08 +0100

>>  	}
>> -	chunk_array_ptr = (uint64_t *)(unsigned long)(cs->chunks);
>> +#ifdef CONFIG_COMPAT
>> +	if (is_compat_task())
> 
> Are the COMPAT ifdefs really needed? The compiler should optimize that
> away anyways on non compat aware architectures, shouldn't it?

There are no non-compat is_compat_task() definitions, nor are there
non-compat build definitions of compat_uptr_t and the assosciated
interfaces.
