Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbYLFP0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbYLFP0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 10:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYLFP0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 10:26:39 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:32928 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756865AbYLFP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 10:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f/XucHUw6rsMrWJicVA/Z0HeWYJb3DV7MOGghgK1ywCU6xlc7pYsCAiNXRlnEiHai1
         pJlfTD5mgJPtptLhPah7M1uW5cSQ8EI3gqm0/9crxih4dlaSxQjm8CoAbiGpcTCcRp6a
         jNwSlK3x3xgB8Q5FOHg49XL6kWcAbYSyRcBZw=
Message-ID: <2f11576a0812060726m141e1dd0rd2890c2fe3fd5484@mail.gmail.com>
Date: Sun, 7 Dec 2008 00:26:37 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Oleg Nesterov" <oleg@redhat.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix taskstats->hiwater_xxx accounting
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>, "Jay Lan" <jlan@sgi.com>,
       "Jiri Pirko" <jpirko@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081204135250.GA5448@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203181220.GA22918@redhat.com>
	 <Pine.LNX.4.64.0812031957570.19174@blonde.anvils>
	 <20081204135250.GA5448@redhat.com>
X-Google-Sender-Auth: f5f37364acd3ff16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg

> But the difference can be huge. Let's suppose the process has 2 threads
> T1 and T2.
>
> T1 exits, calls update_hiwater_vm(), notices that mm->hiwater_vm must be
> updated, and preempted right before mm->hiwater_vm = new_value.
>
> T2 does free(malloc(A_LOT)) and exits. It sets the correct value for
> ->hiwater_vm which takes A_LOT into account and disappears.
>
> T1 resumes, and "reverts" ->hiwater_vm to the "new_value" which was
> calculated before.
>
> Now, since T1 is the last exiting thread, the whole thread group
> exits and we report the wrong ->hiwater_vm to the userspace.
>
> Yes, this race is unlikely. But there is another reason (perhaps
> not very good) why I tried to remove update_hiwater_xxx() from
> do_exit().

This explain is very good clarification than current patch description, IMHO.
So, if possible, I hope to add it into the patch description.

thanks.
