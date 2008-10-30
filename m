Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbYJ3Sig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbYJ3Sig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYJ3Si1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:38:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:20384 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbYJ3Si0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=flIAe7kENMScHmeJXQTGhJDjeLLEfMJFWGXutyw6pArLd7cxj6X723p8xfGydh4wxA
         OcX/WAJ+DMFDhYMKQ4rrjfGaxAgBjUnuw3BHB1zkySKoZjGsCqefxjga6tw4MZZ9ERuA
         eVno20Hjn3apxu4HZdGiNTjv8Zd2+VUxTlixM=
Message-ID: <c62985530810301130q41cc5c0ete2d7610d2172775@mail.gmail.com>
Date: Thu, 30 Oct 2008 19:30:20 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081030182056.GA14102@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490A08E3.2040201@gmail.com> <20081030182056.GA14102@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/30 Ingo Molnar <mingo@elte.hu>:
> hm, are you aware of the -finstrument-functions feature of GCC?
>
> that feature generates such entry points at build time:
>
>                   void __cyg_profile_func_enter (void *this_fn,
>                                                  void *call_site);
>                   void __cyg_profile_func_exit  (void *this_fn,
>                                                  void *call_site);

Oh I didn't know it.
But wouldn't it conflict with the -pg used for mcount in ftrace?

> this might be faster/cleaner than using a trampoline approach IMO.

Yes, oubviously!

> OTOH, entry+exit profiling has about double the cost of just entry
> profiling - so maybe there should be some runtime flexibility there.
> Plus the same recordmcount trick should be used to patch up these
> entry points to NOP by default.

Yes that's right. Hm I don't know what to do since there is already mcount....
