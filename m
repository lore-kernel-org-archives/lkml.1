Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0BRNpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 08:45:43 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:52908 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0BRNpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 08:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=SxnImhcRwUU+Oeo3bxxuoFRduNRltx/ZA5eo6Cy/X7L//KVz7p7CxX/LeKTVU6KJp5
         nkQAUAfeCKtBEHWyKs7DlHHkmlxe+YLhFHdIrCCQvfeRqPhvL0NV0t1eWL8WhBFDuEV0
         aIf6GQALxT5iRTbTpAmAOXlVwG/kFf6wkGYLQ=
MIME-Version: 1.0
In-Reply-To: <1266496346.26719.464.camel@laptop>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <1266488742.26719.119.camel@laptop>
	 <ff13bc9a1002180250t5c9acb54ib8609b4e752520c5@mail.gmail.com>
	 <1266490846.26719.206.camel@laptop>
	 <ff13bc9a1002180429p3afc7313sfb65e980b3c198f2@mail.gmail.com>
	 <1266496346.26719.464.camel@laptop>
Date: Thu, 18 Feb 2010 14:45:40 +0100
X-Google-Sender-Auth: 34dfc95a2011ebe0
Message-ID: <ff13bc9a1002180545y219321acs7b9b348ddcb18f51@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Depends on where on the stack you're going to save things, I through
> you'd take space in the thread_info struct, but I guess if you're simply
> going to push the reg onto the stack it should be fine.

Yes, this seems the best solution.
With frame pointers enabled, it's just a single andl $-8, %esp to
align the stack (otherwise, frame pointers are forced by gcc).
