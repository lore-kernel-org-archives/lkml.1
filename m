Return-Path: <linux-kernel-owner+w=401wt.eu-S1764148AbYBOCR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764148AbYBOCR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbYBOCRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:17:48 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:12557 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbYBOCRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:17:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hexA1CGHY2p67cSBut8jP3eQG88I7kFxKgC750B4bbYoG8qOjQOFHRfCBWYWo/rEamd2IjkRxejdzq2OHXJz9MEB6ETwPUnXGwjz1GA90XnA6DziZ4jy/1n6yWMuPuudrB/RlopJCpBvDRoJPGFqtiZ9hVBVhg7nfN597qF9SMw=
Message-ID: <12c511ca0802141817i3295e83cxd7c05e07f2c54fea@mail.gmail.com>
Date: Thu, 14 Feb 2008 18:17:45 -0800
From: "Tony Luck" <tony.luck@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC97C8B0@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213125725.GC6344@elte.hu>
	 <20080213.050340.64342037.davem@davemloft.net>
	 <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	 <20080213.170452.68851396.davem@davemloft.net>
	 <12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
	 <adaprv0rygh.fsf@cisco.com>
	 <12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com>
	 <ada7ih7qjoq.fsf@cisco.com>
	 <1FE6DD409037234FAB833C420AA843EC97C8B0@orsmsx424.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We *ought* to be safe after cpu_init() ... which is called from setup_arch(),
> which is several calls before sched_init().

Perhaps what is happening is that cpu0 comes online ... safely skips
over the early printk calls.  Calls cpu_init() which sets up the resources
*it* needs (ar.k3 points to per-cpu space), and then executes
sched_init() which marks it safe for all printk's. Then cpu1 comes
up and does a printk before it gets to cpu_init().

Try with Ingo patch and CONFIG_SMP=n to see if you can come
up on a uni-processor.

-Tony
