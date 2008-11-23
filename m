Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYKWQ1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYKWQ1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYKWQ1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:27:31 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:7151 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYKWQ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lv20XyOI8z1C08Kv/LjqBj7ajAsTUVjYSx8KqceDKjtYqkd1n3hHa4mYGbWvaDZAqK
         CEAROjW2nk950tgeY4NwLeTq4PIYoNN8GOhJuIdLi0uKxtjpUHLR/C/hMNcON2VMJE1/
         siM1XrJuklsNcp76vWDpo+hIS4FEe2rw9PJVE=
Date: Sun, 23 Nov 2008 19:27:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce X86_ assembly names macros to catch
	unbalanced declaration
Message-ID: <20081123162728.GF27396@localhost>
References: <20081123161455.GE27396@localhost> <20081123162257.GB570@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123162257.GB570@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Nov 23, 2008 at 05:22:57PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > It's usefull to catch unbalanced or messed declarations of ENTRY and
| > KPROBES. These macros would help a bit (at least I hope so).
| > 
| > For example the following code would compile without problems
| > 
| > 	X86_ENTRY(mcount)
| > 		retq
| > 	X86_END(mcount)
| > 
| > But if you forget and mess the following form
| > 
| > 	X86_ENTRY(mcount)
| > 		retq
| > 	END(mcount)
| > 
| > 	X86_ENTRY(ftrace_caller)
| > 
| > The assembler will issue the following message:
| > Error: X86_ENTRY/KPROBE unbalanced or missed
| 
| looks good - a very small detail: i'd suggest ENTRY_X86()/END_X86() - 
| because whoever is reading this portion of the code is amply aware of 
| the fact that this is the x86 tree - so the more important information 
| should come first.
| 
| 	Ingo
| 

Will fix shortly :)

		- Cyrill -
