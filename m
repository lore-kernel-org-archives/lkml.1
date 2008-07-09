Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYGIPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYGIPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbYGIPZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:25:17 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:52408 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbYGIPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lq5rUJIFgjDfExPbRoGH7oOzTlRbLN47w/T5CAwfNYtSKpfszOHmuT4bgzgQUKEPP+
         9w0XXWxpvrQiaTgAssu/ysGMJKeh9LjiQUaT1B8qD/BW1lUL7JgYe8kRwpaFNiN20Gzh
         He7dGH6+4V8wNhGXx6wJtzaYlA1jdWokw9MAU=
Date: Wed, 9 Jul 2008 19:25:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] early params NULL pointer deref fix
Message-ID: <20080709152505.GA6784@asus>
References: <486f61a9.1e35440a.5815.ffffbc7d@mx.google.com> <20080709115746.GA19060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709115746.GA19060@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Jul 09, 2008 at 01:57:48PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| >  This series fix a possible NULL pointer deref in case if user was 
| > stupid enough to pass boot parameter without a mandatory value
| > 
| >  Actually there is a number of such issues on other platforms too 
| > (like powerpc, sh, s390) so I think it should be fixed too (any 
| > volunteers?)
| > 
| >  Any comments are welcome.
| 
| thanks Cyrill, i picked them up.
| 
| I'm wondering, would it be possible to filter NULL out on one higher 
| level? Would it break any existing functionality? (i dont think it would 
| or should)
| 
| 	Ingo
| 

well, actually it would and should :)

Currently parser does a simple thing - just parses command line and split
key/param pairs. But kernel code uses it in three ways:

 1) as simple flag specified on booting
 2) as key and value
 3) combination of 1) and 2)

So for now I don't see any simple solution for this. We could use '='
param postfix to specify that a mandatory value required for param and
throw out any misconfigured boot options but it will make way 3) invalid
so kernel code will have to be fixed then. So some additional review
and conversation about this are needed.

		- Cyrill -
