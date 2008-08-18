Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbYHROjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbYHROjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754221AbYHROja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:39:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51560 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbYHROj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rpoTn6thlVCd4SH/zao8KfqqFjSVLwGCNKWbB0qdPG9MP0muFhg+I1IkDwZimjuPNL
         LaPuHQ9u+/fWa+aHN8TEjVh9SrEmopGCp9mZMxt5BWhulROG0wV3tUqRD3lQ4qYkviyu
         WOx8g05i762G+fy+5SIp9BHPSpjCvygYLPX5c=
Date: Mon, 18 Aug 2008 18:39:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] x86: apic - unify lapic_resume
Message-ID: <20080818143943.GA7237@lenovo>
References: <1218914515-26377-1-git-send-email-gorcunov@gmail.com> <f87881899957b7aa08b827cdc6b5dd8cf53e4730.1218914042.git.gorcunov@gmail.com> <722b5bc0303212ca203cadeedae5ede3e23eccb7.1218914042.git.gorcunov@gmail.com> <Pine.LNX.4.55.0808162041190.17944@cliff.in.clinika.pl> <20080816130008.349b031d@infradead.org> <20080816201235.GB7182@lenovo> <Pine.LNX.4.55.0808181506230.29123@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0808181506230.29123@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Mon, Aug 18, 2008 at 03:19:05PM +0100]
| On Sun, 17 Aug 2008, Cyrill Gorcunov wrote:
| 
| > it seems this limit is not APIC related since iirc 82489DX allows
| > to address 2^14 bits, x2APIC - more then 128 entities too. So I suspect
| > it somehow cpu bitmap related. Am I wrong (I didn't _check_ the code)?
| 
|  For the record: the 82489DX supports an 8-bit physical unit ID so 256
| distinct values are supported.  Of these I gather 255 is taken for the
| broadcast ID in the physical destination mode, but that is nowhere
| explicitly confirmed in the 82489DX docs (it can be implied from protocol
| description though).  While the ID is indeed 8-bit in the 82489DX, for
| systems where future compatibility was a concern Intel recommended the use
| of IDs from 0 through to 14 only in anticipation of the future integrated
| APIC with the physical mode addressing capability limited to 4 bits only
| (and 15 taken for the broadcast ID).
| 
|  Full 32 bits are available with the 82489DX for the logical destination 
| mode and only the flat (no cluster) mode is supported.
| 
|   Maciej
| 

Thanks, Maciej! The doc says to use 0-14 so I misinterpreted it as
bits :(. I've to be more carefull next time. Thanks!

		- Cyrill -
