Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYKURHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYKURHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYKURHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:07:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41979 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYKURHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:07:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BnifH0J6WHN1r0dRF/mVyUKtzym6rfmmCcgLyxRa9U+ZuQUc9a74WdX+M0zAEsxmq4
         k1PUGR7dhSp0KlZtk/gy5+QR61PZCQXI0dCJ5WMjKUCFR8xeEE6iCj9YaEIreUeumUUI
         txlH0VT4Z58+NX1s4zj1N14bFC2s9DMRF2l5g=
Date: Fri, 21 Nov 2008 17:07:11 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] uml: fix undeclared variables
Message-ID: <20081121170711.GA23653@hack.voiplan.pt>
References: <20081118174250.GE3185@hack.voiplan.pt> <20081118192626.GU28946@ZenIV.linux.org.uk> <20081119184014.GD22898@hack.voiplan.pt> <20081119190636.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119190636.GW28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 07:06:36PM +0000, Al Viro wrote:
>On Wed, Nov 19, 2008 at 06:40:14PM +0000, Am??rico Wang wrote:
>> On Tue, Nov 18, 2008 at 07:26:26PM +0000, Al Viro wrote:
>> >On Tue, Nov 18, 2008 at 05:42:51PM +0000, Am??rico Wang wrote:
>> >> 
>> >> Fix three compile errors about undeclared variables in
>> >> arch/um/kernel/mem.c.
>> >
>> >And what, pray tell, would initialize it?
>> 
>> Sorry, I can't fully understand you. I got the following error:
>> 
>> arch/um/kernel/mem.c: In function ???init_highmem???:
>> arch/um/kernel/mem.c:177: error: ???pkmap_page_table??? undeclared (first
>> use in this function)
>> arch/um/kernel/mem.c:177: error: (Each undeclared identifier is
>> reported only once
>> arch/um/kernel/mem.c:177: error: for each function it appears in.)
>
>The error is there, all right.  However, proposed patch only hides the
>real problem.  Building uml/i386 with CONFIG_HIGHMEM will result in
>a badly broken kernel with that patch, with no visible hints at the
>cause of problems.
>
>You've got it to link, but that's not enough.  The problems you are seeing
>come from arch/x86/mm/highmem_32.c.  It uses several variables from
>arch/x86/mm/init_32.c and you have copied them to arch/um.  However, getting
>these variable defined is not going to make it work - the code that used
>to set it had been in init_32.c too and you've just left your copy initialized
>to NULL.  Which will *not* work.
>

Thanks for teaching this! I will look deep into this problem.


-- 
"Sometimes the only way to stay sane is to go a little crazy."

