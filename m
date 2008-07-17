Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYGQM04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYGQM04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYGQM0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:26:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:51881 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYGQM0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CcnPCV8P83tTegunSBKRR4dRW8XHPB2ovWyb5pQNddMhBuKJUv3J7WRxi1Ywbprr1t
         ROSsYepdJndmAtwjJLgSfHLMBRsnqr4MCm1gbl0rVX1Bx8Co2HhoTIE/X1UBhdf9JUpE
         zTikdOj8QPUFodz8AonO1QDCsauRTC5wzyFMY=
Message-ID: <84144f020807170526x6f013357i29280595f65a67f4@mail.gmail.com>
Date: Thu, 17 Jul 2008 15:26:46 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Robin Holt" <holt@sgi.com>
Subject: Re: SLUB: simplify re on_each_cpu()
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080717113826.GG8534@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716172902.GA5176@martell.zuzino.mipt.ru>
	 <20080717113826.GG8534@sgi.com>
X-Google-Sender-Auth: 1a2a3e406a6cbba2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

On Wed, Jul 16, 2008 at 09:29:02PM +0400, Alexey Dobriyan wrote:
>> on_each_cpu() expands to function call on UP, too.

On Thu, Jul 17, 2008 at 2:38 PM, Robin Holt <holt@sgi.com> wrote:
> It looks to me like on_each_cpu is a #define for !SMP.  Are you certain
> of the need for this change?  Are you looking at a different tree than
> Linus'?

I think it's actually you who is looking at an older tree.

However, while double-checking this, I noticed that for UP,
on_each_cpu() enables interrupts unconditionally with
local_irq_enable() whereas the call while the old code in SLUB did a
local_irq_restore() that preserves the irq mask. Looking at the
callers of flush_all() in mm/slub.c, the change looks okay, but it's
still bit strange on_each_cpu() works that way on UP.

                          Pekka
