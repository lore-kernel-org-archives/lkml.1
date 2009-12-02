Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZLBOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZLBOG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZLBOG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:06:59 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:51851 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbZLBOG6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;7:1>);
	Wed, 2 Dec 2009 09:06:58 -0500
Message-Id: <4B168293020000780002308E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Dec 2009 14:06:59 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <a.p.zijlstra@chello.nl>, <tglx@linutronix.de>,
       <torvalds@linux-foundation.org>, <mingo@redhat.com>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-tip-commits@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten
	 __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
 <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
 <20091202132937.GA1564@elte.hu>
In-Reply-To: <20091202132937.GA1564@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 02.12.09 14:29 >>>
>at first quick sight, this bit looks odd:
>
>+       union { int i; bool b; } new;
>
>+       return new.b;
>
>shouldnt that be short based, to work correctly in the 0-255 CPUs case?

No, I can't see why. In both instances, we're using (and had been
using previously, just with the added movzbl) the outcome of a
setCC instruction, which produces valid bool (single byte) values.
It is precisely that reason why I needed to introduce these unions,
since the upper bytes of the register aren't valid (and shouldn't be
looked at by the caller).

Do you happen to have the vmlinux binary still around, to look at
the code your compiler generated (I went through the code I got
in quite a bit of detail to make sure it got translated correctly)?

Jan

