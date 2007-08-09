Return-Path: <linux-kernel-owner+w=401wt.eu-S936214AbXHIKve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936214AbXHIKve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 06:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXHIKv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 06:51:26 -0400
Received: from ns2.suse.de ([195.135.220.15]:54783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXHIKvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 06:51:25 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
Date: Thu, 9 Aug 2007 12:51:21 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
References: <183884.85434.qm@web26915.mail.ukl.yahoo.com>
In-Reply-To: <183884.85434.qm@web26915.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708091251.21726.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  Note that Gujin has a simple problem by using that 32 bits entry point:

There is really no 32bit entry point today usable for external users. Or rather
it might by chance work today, but if we change the zero page (and there
is no guarantee it'll not be changed). I can pretty much guarantee it'll
be changed at some point. And you'll break if you use it.

kexec can use the 32bit entry, but only because it is in tree so it can be fixed 
up for any changes.

If you want to use it you would need to define some versionable protocol
first similar to the real mode boot protocol. That would require some work
and some thought to make sure it is forwards and backwards compatible.

I'll add a comment to zero-page.txt to make this more clear. Just because
something is documented in Documentation doesn't mean it's an external stable
ABI.

-Andi
