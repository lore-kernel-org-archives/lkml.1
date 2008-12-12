Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYLLEvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYLLEvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYLLEvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:51:40 -0500
Received: from mail-gx0-f12.google.com ([209.85.217.12]:39507 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbYLLEvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=K2/DJQeQIuDKi9y4Rs4MPcwnUQd0q94j540vbBJcSCGfnplolm/JHw06rWhp6tLpeR
         J+83Mr03qqB+w6rQDC3+lOrd6hpFUSESp48l26MdB0xll0qZufyL2HgD4LyrIAE7Gg2V
         Pcb45cu65F5L7XiB9olsnnoMv9Geb+1vpkBdw=
Message-ID: <9929d2390812112051p2fcaaa22lcb8ae3edcb1ed2d3@mail.gmail.com>
Date: Thu, 11 Dec 2008 20:51:37 -0800
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] e1000e: fix double release of mutex
Cc: akpm@linux-foundation.org, frederik.deweerdt@xprog.eu,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, zdenek.kabelac@gmail.com
In-Reply-To: <20081211.203119.180062878.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211215806.1173.24413.stgit@lost.foo-projects.org>
	 <20081211.203119.180062878.davem@davemloft.net>
X-Google-Sender-Auth: a9faaa124e0f2925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 8:31 PM, David Miller <davem@davemloft.net> wrote:
> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Date: Thu, 11 Dec 2008 13:58:07 -0800
>
>> During a reset, releasing the swflag after it failed to be acquired would
>> cause a double unlock of the mutex.  Instead, test whether acquisition of
>> the swflag was successful and if not, do not release the swflag.  The reset
>> must still be done to bring the device to a quiescent state.
>>
>> This resolves [BUG 12200] BUG: bad unlock balance detected! e1000e
>> http://bugzilla.kernel.org/show_bug.cgi?id=12200
>>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>
> If we're fixing a regression like this, you should make the
> patch against net-2.6, and this one is against net-next-2.6
>
> Please respin this for me, thanks Jeff.
> --
>

Doh! Sorry Dave.  My bad, respinning now.

-- 
Cheers,
Jeff
