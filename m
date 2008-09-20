Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbYITNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbYITNpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 09:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYITNps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 09:45:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:51655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYITNpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 09:45:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DxFNa80GwDdSJUPtkeN/r+ZUDN6aWisolqFMoEKY6JJ+TKdSPrsRdHrvqh6YDtXDUI
         2Q+cHWPm6z8BC6LxghmD6iZo+dBbd5TFVLVKut6mp603DI5qtpkbG6V1ydsVKeIRRAA8
         dK9CE+jEZDxKUhYtwdYJDcBHXaaXHVIUi97mQ=
Date: Sat, 20 Sep 2008 17:45:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christer Weinigel <christer@weinigel.se>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Russ Dill <russ.dill@gmail.com>,
       Eric Miao <eric.y.miao@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement
	ARRAY_SIZE().
Message-ID: <20080920134543.GA7354@localhost>
References: <20080918132447.516309749@fluff.org.uk> <20080918150624.GA3421@x200.localdomain> <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com> <20080919065426.GA7222@lenovo> <f17812d70809190022u6c862ae8j43b1c1a942e22497@mail.gmail.com> <f9d2a5e10809190828g54a824b9od1ade53c96a518c8@mail.gmail.com> <20080919175544.GA3228@x200.localdomain> <48D4F519.2080509@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D4F519.2080509@weinigel.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Christer Weinigel - Sat, Sep 20, 2008 at 03:05:29PM +0200]
> Alexey Dobriyan wrote:
>> On Fri, Sep 19, 2008 at 08:28:45AM -0700, Russ Dill wrote:
>>> My vote is for ARRAY_AND_SIZE to spread far and wide across the land.
>>> ARRAY_SIZE is already very safe, as it has a __must_be_array macro
>>> built in. So ARRAY_AND_SIZE is even safer, as it prevents you from
>>> mixing up two different arrays. It also reduces line length and makes
>>> driver and device (usually platform_device) registration code easier
>>> to read.
>>
>> It also spreads ARRAY_SIZE misnaming futher.
>
> You still haven't explained what's misnamed about it, nor suggested a  
> better name.
>
>> It introduces one more core macro and quite pointless one. I can't
>> personally recall a single bug where sizeof() was taken from another
>> array.
>
> You haven't written a lot of machine definitions then.  When adding  
> platform devices for an embedded platform one has to write a lot of  
> boilerplate like this:
>
>     platform_add_devices(n30_devices, ARRAY_SIZE(n30_devices));
>
> and it is much too easy to copy paste that line and miss one of the  
> references.
>
>> It creates interesting confusion point: ARRAY_AND_SIZE is about array
>> and it's size. What ARRAY_SIZE is about then?
>
> ARRAY_AND_SIZE -> (An) array and (its) size
>
> ARRAY_SIZE -> (The) array size
>
> Sure, you could write ARRAY_AND_ITS_SIZE, but would that really make  
> anyone happy?  Cobol went out of fashion a long time ago.
>
>   /Christer
>

Christer, _I_ was complaining not about naming
but about hiding function arguments. I suppose
it's better to define some inline wrapper for
platform_add_devices then use such a macro.

If you google a bit you may find that I was asking
someday why don't we define alias for memset when
we just it as _clearing_ routine ie memset(x, 0, sizeof(x)).

		- Cyrill -
