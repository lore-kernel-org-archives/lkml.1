Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZIUMgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZIUMgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZIUMgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:36:08 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:41146 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755764AbZIUMgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:36:07 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 08:36:07 EDT
Message-ID: <4AB771B3.8080603@vflare.org>
Date: Mon, 21 Sep 2009 17:59:39 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>	 <Pine.LNX.4.64.0909180809290.2882@sister.anvils>	 <1253260528.4959.13.camel@penberg-laptop>	 <Pine.LNX.4.64.0909180857170.5404@sister.anvils>	 <1253266391.4959.15.camel@penberg-laptop> <4AB3A16B.90009@vflare.org>	 <4AB487FD.5060207@cs.helsinki.fi>	 <Pine.LNX.4.64.0909211149360.32504@sister.anvils>	 <1253531550.5216.32.camel@penberg-laptop>	 <Pine.LNX.4.64.0909211244510.6209@sister.anvils> <84144f020909210508i7e8b1b3bif61dcb5b576c878d@mail.gmail.com>
In-Reply-To: <84144f020909210508i7e8b1b3bif61dcb5b576c878d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2009 05:38 PM, Pekka Enberg wrote:
> Hi Hugh,
> 
> On Mon, Sep 21, 2009 at 2:55 PM, Hugh Dickins
> <hugh.dickins@tiscali.co.uk> wrote:
>> Though exporting the swap_info_struct still bothers me, and it
>> seems convoluted that the block device should have a method, so
>> swapon can call the block device, so the block device can call
>> swapfile.c to install a callout, so that swapfile.c can call the
>> block device when freeing swap.  I'm not saying there is a better
>> way, just that I'd be glad of a better way.
> 
> I guess we can combine my ->swapon() hook in struct
> block_device_operations with Nitin's set_swap_free_notify() function
> to avoid exporting struct swap_info_struct. Alternatively, we could
> add the ->swap_free() hook too struct block_device_operations. In any
> case, I don't think we can do the setup at sys_open() if we keep
> Nitin's hook as struct swap_info_struct is not set up until
> sys_swapon().
> 
>                      


I just converted all this to use more generic notifier interface and tested
it by adding ramzswap notifier to list and it all works. I will shortly send
RFC patches for swapfile.c changes and corresponding ramzswap changes to show
its usage.

I'm still not sure if these notifiers will find more users, making all this
look like a mere decoration. But, at least it looks better than whatever
hack we currently have :)

(I will do better patch division when I post the next revision).

Thanks,
Nitin
