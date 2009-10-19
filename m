Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZJSPCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZJSPCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZJSPCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:02:50 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:65470 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbZJSPCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GpfhVMGjGYi7/jeVF/uTb4zRij2gL8J7fHpl3bLUa4/fDxFcPC9/PQURVf6Mwf3wYa
         2D44eaV4bsqUQIJlhsdpEIzHviM00T6BiLlNy3u8SUVgTLT8ZP5F47TAkngSEtRauTRg
         J9NSbKECC2uAGZxcnOGKFRZzPnRmMc+rJb0J4=
MIME-Version: 1.0
In-Reply-To: <20091019132205.GA7192@kroah.com>
References: <4ADACD3A.9020803@gmail.com>
	 <9b2b86520910180544g94ecc8fuf0d7849e18cd8937@mail.gmail.com>
	 <20091018214704.GA26592@kroah.com>
	 <2ccd6e3c0910190445va8ff4a8x94dc4044ac01057d@mail.gmail.com>
	 <20091019132205.GA7192@kroah.com>
Date: Mon, 19 Oct 2009 17:02:51 +0200
Message-ID: <2ccd6e3c0910190802w117f8ac1nb562214786904c04@mail.gmail.com>
Subject: Re: Fast LKM symbol resolution with SysV ELH hash table
From: Carmelo Amoroso <carmelo73@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/19 Greg KH <greg@kroah.com>:
> On Mon, Oct 19, 2009 at 01:45:20PM +0200, Carmelo Amoroso wrote:
>> Just a few other notes. The current implementation I did based on SysV
>> has a drawback that is not backward compatible, so you cannot use old
>> modules with a kernel with the option enabled due to changes on struct
>> kernel_symbol.
>
> Why would this be a problem?  Whenever making a kernel config change,
> you should be able to rebuild everything, as lots of other configuration
> options are that way.
>

This is not always true... there could be cases in which you cannot
recompile old modules
(e.g vendors that provide non GPL modules)

>> Anyway I've just figured out how to change it to remove this limitation.
>> I need some time to review these patches.  Further, the newer
>> implementation based on GNU hash which we are working on right now,
>> will not require the extra .undef.hash ELF sections because hash
>> values are already embedded into the GNU hash table, with a reduction
>> in terms of footprint.
>
> Footprint in the memory for the loaded module, or just in the footprint
> for the module on the disk?
>

both

> I'd be interested in seeing your patches when you have something that
> works for the current Linus kernel tree.
>

sure. I tested weeks ago it on a 2.6.30 tree on x86 at it worked
without problems.
I had to hack the x86  linker scripts to remove a check on file size
that sounded strange
to me.

carmelo

> thanks,
>
> greg k-h
>
