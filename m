Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZANW1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZANW1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZANW0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:26:52 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:56107 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbZANW0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:26:50 -0500
Message-ID: <d6200be20901141426r1d48ea33gc9a380451e4aaf93@mail.gmail.com>
Date: Wed, 14 Jan 2009 14:26:48 -0800
From: "=?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?=" <arve@android.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: lowmemory android driver not needed?
Cc: "Pavel Machek" <pavel@suse.cz>, "Greg KH" <greg@kroah.com>,
       "Brian Swetland" <swetland@google.com>, arve@google.com,
       "San Mehat" <san@android.com>, "Robert Love" <rlove@google.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090114104834.18387fca@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20090114010223.GA21380@kroah.com>
	 <20090114021801.GA14759@bulgaria.corp.google.com>
	 <d6200be20901131830r7103ff8eoe0314f9faf89d89b@mail.gmail.com>
	 <20090114035237.GB16442@kroah.com> <20090114104307.GA20451@elf.ucw.cz>
	 <20090114104834.18387fca@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 2:48 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Maybe our oom killer should get a new tunable, telling it how
>> aggressive it should be, instead?
>
> I was thinking that, and it would integrate better with the OLPC work
> (which IMHO is a nicer interface for some stuff)
>
> You'd want two thresholds
>
> The 'arghhhh....' point where you start killing stuff
> The 'uh oh...' point where an OLPC style low memory notifier kicks in

We actually use 6 different thresholds for killing processes. I don't
know what all the classes are, processes with a higher oom_adj value
can be killed with less impact to the user than processes with a lower
oom_adj value. The first few classes only affect latency when
switching apps, but later classes stop non critical background
services and finally the foreground app. Another reason to not kill
every process at the same threshold is that memory may not be free
immediately when the process is killed.

-- 
Arve Hjønnevåg
