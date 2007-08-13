Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbXHMVXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbXHMVXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbXHMVWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:22:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19685 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856AbXHMVWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IzZFO93zCAd1eWUSyRxaPhggn7CH8sNUJYKU/Tsuwm3hZhE2grUOAUfhnWdMevVCQmKVAr7kcMKFAfEQCAa97Z8UJWsoJcw8JJWd3GI+hQoE3upEVfK3z75ZQ+XxnQtMAIUnRPOvhuHBJ0Lwa5KhXCMqMUeYlPp6KOEN88eiLvg=
Date: Tue, 14 Aug 2007 01:22:39 +0400
From: Sergey Dolgov <solkaa@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3 regression and bisection query
Message-ID: <20070813212204.GA2645@slk.laptop>
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 07:44:48PM +0100, Hugh Dickins wrote:

> Git bisection (with manual fixups to i386 mmiocfg horror, thanks
> for drawing attention to that in your changelog) accuses Alexey's
> ACPI: EC: If ECDT is not found, look up EC in DSDT
> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> and if I revert that along with Len's subsequent
> ACPI: EC: fix build warning
> 52fe4bdf40bc07498c5f7935551774e8f8458190
> then I have Fn-F4 suspending to RAM again.
> 

I've also noticed a regression since -rc2 in battery status reporting
on my HP nx7300 laptop: the output of

    cat /proc/acpi/battery/C1BE/state

does not change after this file has been read for the the first time;
for exaple, the line "charging state: charged" does not change to
"charging state: discharging" upon unplugging the power cord.

Reverting the above 2 commits fixes this issue for me.

--
Sergey
