Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZIUMIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZIUMIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbZIUMIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:08:02 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40313 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZIUMIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=S9XYdN168Irsh4qceKMGCehbQgThh/plGoCKuGFOISCimIayFOo0eErPqhk9DXTZJc
         Uj/6m4T5vMCivptjfXiOuwEmF15KytTgy57MVcb1RxaFOldFsQ9NU5FwCN0UEWEA3AUw
         nnGiRcIeHbulLslquGOYEH04OXF3uAOCnhby8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909211244510.6209@sister.anvils>
References: <1253227412-24342-1-git-send-email-ngupta@vflare.org>
	 <Pine.LNX.4.64.0909180809290.2882@sister.anvils>
	 <1253260528.4959.13.camel@penberg-laptop>
	 <Pine.LNX.4.64.0909180857170.5404@sister.anvils>
	 <1253266391.4959.15.camel@penberg-laptop> <4AB3A16B.90009@vflare.org>
	 <4AB487FD.5060207@cs.helsinki.fi>
	 <Pine.LNX.4.64.0909211149360.32504@sister.anvils>
	 <1253531550.5216.32.camel@penberg-laptop>
	 <Pine.LNX.4.64.0909211244510.6209@sister.anvils>
Date: Mon, 21 Sep 2009 15:08:04 +0300
X-Google-Sender-Auth: 9e93f5547e120867
Message-ID: <84144f020909210508i7e8b1b3bif61dcb5b576c878d@mail.gmail.com>
Subject: Re: [PATCH 2/4] send callback when swap slot is freed
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: ngupta@vflare.org, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, Sep 21, 2009 at 2:55 PM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> Though exporting the swap_info_struct still bothers me, and it
> seems convoluted that the block device should have a method, so
> swapon can call the block device, so the block device can call
> swapfile.c to install a callout, so that swapfile.c can call the
> block device when freeing swap.  I'm not saying there is a better
> way, just that I'd be glad of a better way.

I guess we can combine my ->swapon() hook in struct
block_device_operations with Nitin's set_swap_free_notify() function
to avoid exporting struct swap_info_struct. Alternatively, we could
add the ->swap_free() hook too struct block_device_operations. In any
case, I don't think we can do the setup at sys_open() if we keep
Nitin's hook as struct swap_info_struct is not set up until
sys_swapon().

                        Pekka
