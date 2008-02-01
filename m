Return-Path: <linux-kernel-owner+w=401wt.eu-S1755665AbYBATRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbYBATRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 14:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbYBATQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 14:16:39 -0500
Received: from gw.goop.org ([64.81.55.164]:35756 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031AbYBATQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 14:16:37 -0500
Message-ID: <47A36FF2.8000804@goop.org>
Date: Fri, 01 Feb 2008 11:16:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [12/12] GBPAGES: Switch direct mapping setup over to
 set_pte
References: <200802011053.107168490@suse.de> <20080201095325.6419E1B416F@basil.firstfloor.org> <47A358DB.4010602@goop.org> <200802011858.41269.ak@suse.de>
In-Reply-To: <200802011858.41269.ak@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Why?  64-bit Xen will need this to be set_pmd if its an update to L2 of
>> the table.
>>     
>
> Then change_page_attr() and hugepages will already not work because they both 
> do exactly that.
>
> And I didn't want to duplicate this manual code for the GBpages case, so i 
> changed it everywhere to the standard way.

It's a bit moot because Xen doesn't support any kind of large page yet, 
but there has been some work in that area.  The main problem with using 
set_pte is that Xen supports trap'n'emulate for pte-level accesses, but 
not for upper levels.

Looks like you're right about the rest of cpa; may as well make it all 
consistent for now, and we can fix it later when the need arises.

    J
