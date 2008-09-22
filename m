Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYIVKho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYIVKho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIVKhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:37:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:7503 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbYIVKhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LHslzNucGoV1kJlUZr83g1VUMBrPtH1CCjUfoCPm4a8QZg+H08eX1Mr6KfNw3jC5RR
         /ReKL0eX2Vc35v3/3XJhIyqkkKQ+6P2L6+CAWwRyRn24qZJIpppwueWCjMdrgm3tE+T6
         giiqagk4q2lY9DyNzSgTlcV3k9DoB1WycgBn0=
Date: Mon, 22 Sep 2008 14:37:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080922103736.GA22024@localhost>
References: <20080919123320.GF7222@lenovo> <20080922090405.GA12630@elte.hu> <86802c440809220301l662824aasa9cf3a437f42bd9@mail.gmail.com> <20080922100532.GD24705@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922100532.GD24705@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Sep 22, 2008 at 12:05:32PM +0200]
| 
| * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
| 
| > On Mon, Sep 22, 2008 at 2:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
| > 
| > BTW
| > 
| > x2apic and IRmapping make io_apic.c and apic.c ugly.
| 
| yes. Any ideas how to clean it up some more?
| 
| the kmalloc looks quite ugly, especially with this kfree() teardown 
| sequence we have now.
| 
| 	Ingo
| 

yes Ingo - it's ugly but I had not that many choises:

1) allocate/deallocate if failed inside same routine
2) deallocate in restore_IO_APIC_setup (which would be much more
   ugly and obscure)
3) allocate and deallocate in completely separated routines - didn't
   even tried :)

So I've stopped on (1) 'case it was less_changing_the_sources patch.   

		- Cyrill -
