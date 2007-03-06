Return-Path: <linux-kernel-owner+w=401wt.eu-S965985AbXCFSiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985AbXCFSiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965991AbXCFSiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:38:01 -0500
Received: from gw.goop.org ([64.81.55.164]:40748 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965985AbXCFSiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:38:00 -0500
Message-ID: <45EDB506.70709@goop.org>
Date: Tue, 06 Mar 2007 10:37:58 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
References: <1173184747.4644.23.camel@localhost.localdomain> <1173185592.4644.28.camel@localhost.localdomain> <1173185666.4644.30.camel@localhost.localdomain> <1173185734.4644.32.camel@localhost.localdomain> <1173185827.4644.34.camel@localhost.localdomain> <1173185909.4644.36.camel@localhost.localdomain> <1173186021.4644.38.camel@localhost.localdomain> <1173186107.4644.41.camel@localhost.localdomain> <1173186214.4644.44.camel@localhost.localdomain> <20070306193445.GI22829@bingen.suse.de>
In-Reply-To: <20070306193445.GI22829@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Sigh -- i had hoped this had settled down because it was a
> merging nightmare last time. Ok. 
>
>   
>> +#define percpu_to_op(op,var,val)				\
>> +	do {							\
>> +		typedef typeof(var) T__;			\
>> +		if (0) { T__ tmp__; tmp__ = (val); }		\
>> +		switch (sizeof(var)) {				\
>> +		case 1:						\
>> +			asm(op "b %1,"__percpu_seg"%0"		\
>> +			    : "+m" (var)			\
>> +			    :"ri" ((T__)val));			\
>>     
>
> Perhaps I'm blind but I can't see where the %fs reference is there.
>   
__percpu_seg.  It's defined to nothing in the UP case.

    J
