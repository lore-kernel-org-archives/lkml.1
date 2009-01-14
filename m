Return-Path: <linux-kernel-owner+w=401wt.eu-S1760982AbZANXcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760982AbZANXcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZANXcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:32:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:46026 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbZANXck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:32:40 -0500
Message-ID: <d6200be20901141532y6f236104kd521041d640c152e@mail.gmail.com>
Date: Wed, 14 Jan 2009 15:32:38 -0800
From: "=?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?=" <arve@android.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: lowmemory android driver not needed?
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Pavel Machek" <pavel@suse.cz>,
       "Brian Swetland" <swetland@google.com>, arve@google.com,
       "San Mehat" <san@android.com>, "Robert Love" <rlove@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090114231739.GB24111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090114010223.GA21380@kroah.com>
	 <20090114021801.GA14759@bulgaria.corp.google.com>
	 <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
	 <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz>
	 <20090114104834.18387fca@lxorguk.ukuu.org.uk>
	 <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com>
	 <20090114231739.GB24111@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 3:17 PM, Greg KH <greg@kroah.com> wrote:
>> We actually use 6 different thresholds for killing processes. I don't
>> know what all the classes are, processes with a higher oom_adj value
>> can be killed with less impact to the user than processes with a lower
>> oom_adj value. The first few classes only affect latency when
>> switching apps, but later classes stop non critical background
>> services and finally the foreground app. Another reason to not kill
>> every process at the same threshold is that memory may not be free
>> immediately when the process is killed.
>
> But the lowmemorykiller android module doesn't have anything to do with
> this, right?
>

It does. We write the thresholds to
/sys/module/lowmemorykiller/parameters/adj and
/sys/module/lowmemorykiller/parameters/minfree then set the oom_adj
value per process. If the standard oom killer can be adjusted in a
similar way, then we will not need the lowmemorykiller module.

-- 
Arve Hjønnevåg
