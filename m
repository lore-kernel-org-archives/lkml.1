Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbYHDLAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbYHDLAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 07:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYHDLAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 07:00:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:12864 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHDLAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:00:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XMCP2w0UcfGanwLAgR42qtPEChBn66z1z7kn3lZHGjK0ctOGKigHYdRPDxEFO53hGw
         c8xboWtLZNB+RM93IVcm1OLbyhINTYbvBO+wsBuuiOoBFoa+/RawX/T+rBcF7KOCXuZz
         wlphBWnUwOLeYvCg4otpIGUrW/QYyvEX6RQ4Q=
Message-ID: <93655eb70808040400l236aed0bm841744beff4dd4fe@mail.gmail.com>
Date: Mon, 4 Aug 2008 16:30:21 +0530
From: "Satish Eerpini" <eerpini@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel Installer
In-Reply-To: <93655eb70808040357m2e2893c5n3deb34012d5f212b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <93655eb70808031350q16a5765bk3125e53bd042ba0e@mail.gmail.com>
	 <20080803210051.GF7442@cs181140183.pp.htv.fi>
	 <93655eb70808032045vd6130e9m147d3e3ae8b159b5@mail.gmail.com>
	 <93655eb70808032046y594f38a3u16b7fa2cc6291b1d@mail.gmail.com>
	 <4896CB17.8050701@kernel.org>
	 <93655eb70808040357m2e2893c5n3deb34012d5f212b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

using make -n does not work well for my purpose , because with that ,
the neat kernel compilation output is gone , and i think it is far
more work to make sense out of the entire details make -n gives .

I rather came up with this idea , though i think it is more time consuming , :

--> enter each directory recursively and parse the Makefile for the
files that would be compiled ,
--> this can be done by comparing the "CONFIG_" options which have
been enabled in .config
--> and then should also make note of the other 'objs' being compiled
for the required objects .

but all this has to be done in a way which minimises the amount of CPU
time the installer takes , because while we are running the make for
the compilation , it itself consumes a lot of CPU cyles . (CC
actually) ,........

another obstacle i have faced is recognising when the Linux image is
being built , and when the compiling enters into the second stage ,
viz , building modules ........ but knowing the total no of modules to
be compiled is simple as it is already given out by kbuild.

what i need to know , is there any method by which the total no of
files to be compiled can be computed internally in the kbuild process
itself , ......
or the second method would be to "echo" markers (basically text
messages)  after each stage of the compilation which can be caught by
the installer , ... but i am sure this is not the best of the methods
to be followed , ..........

is this possible ?


On Mon, Aug 4, 2008 at 2:55 PM, Tejun Heo <tj@kernel.org> wrote:
> Satish Eerpini wrote:
>>> Replacing the normal build output with something different doesn't make
>>> anything easier.
>>>
>>> Especially considering that your "once the .config file is set" seems to
>>> assume the user already configured the kernel himself...
>>>
>>
>> i am not just trying to replace the output , i am not a stupid to
>> waste my weekend sitting just to replace the output  :-),
>> if u are interested , u can check out the entire TODO for the app here
>> http://satish.playdrupal.com/?q=node/2
>>
>> but in the process i am stuck at deciding the no of files that will be
>> compiled , given that representing the entire compilation
>> process as a progress bar , would give a clear idea of " how much is
>> over" and "how much is left" !!!
>
> make -n makes make do a dry-run but kbuild is a pretty complex beast and
> you might have to jump through some loops to get the information you want.
>
> --
> tejun
>

Thanks
Satish
--
http://satish.playdrupal.com
