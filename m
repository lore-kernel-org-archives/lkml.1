Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZJSUqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZJSUqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757556AbZJSUqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:46:18 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56731 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZJSUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Gike3D2oOq5uG/fHPrBVp9vm1doSPYRBYGZK/6YgW2Q6gtKiZx/1nVkkVHNcceSCWE
         GIxtyoaxdVveT7EH7/g7SQ020Gvhnh9R37ICxT6J4LVSdMlWvEsXkT1rxjec3zxrvVG5
         YfPf+PokPANpylEHbibCPtUzwapNv3qo6fRAs=
MIME-Version: 1.0
In-Reply-To: <20091019191016.GA3922@kroah.com>
References: <4ADACD3A.9020803@gmail.com>
	 <9b2b86520910180544g94ecc8fuf0d7849e18cd8937@mail.gmail.com>
	 <20091018214704.GA26592@kroah.com>
	 <2ccd6e3c0910190445va8ff4a8x94dc4044ac01057d@mail.gmail.com>
	 <20091019132205.GA7192@kroah.com>
	 <2ccd6e3c0910190802w117f8ac1nb562214786904c04@mail.gmail.com>
	 <20091019191016.GA3922@kroah.com>
Date: Mon, 19 Oct 2009 21:46:20 +0100
Message-ID: <9b2b86520910191346n305a52e6x311b38577d84eaf3@mail.gmail.com>
Subject: Re: Fast LKM symbol resolution with SysV ELH hash table
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: Carmelo Amoroso <carmelo73@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/09, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 19, 2009 at 05:02:51PM +0200, Carmelo Amoroso wrote:
>> 2009/10/19 Greg KH <greg@kroah.com>:
>> > On Mon, Oct 19, 2009 at 01:45:20PM +0200, Carmelo Amoroso wrote:
>> >> Just a few other notes. The current implementation I did based on SysV
>> >> has a drawback that is not backward compatible, so you cannot use old
>> >> modules with a kernel with the option enabled due to changes on struct
>> >> kernel_symbol.
>> >
>> > Why would this be a problem? ?Whenever making a kernel config change,
>> > you should be able to rebuild everything, as lots of other configuration
>> > options are that way.
>> >
>>
>> This is not always true... there could be cases in which you cannot
>> recompile old modules (e.g vendors that provide non GPL modules)
>
> But we do not care at all about that kind of thing, sorry.
>
>> >> Anyway I've just figured out how to change it to remove this
>> >> limitation.
>> >> I need some time to review these patches. ?Further, the newer
>> >> implementation based on GNU hash which we are working on right now,
>> >> will not require the extra .undef.hash ELF sections because hash
>> >> values are already embedded into the GNU hash table, with a reduction
>> >> in terms of footprint.
>> >
>> > Footprint in the memory for the loaded module, or just in the footprint
>> > for the module on the disk?
>> >
>>
>> both
>
> Why would the already-loaded module size increase?
>
> I guess I'll just wait to see the code before worrying about this :)

Modules export symbols, as well as importing them :).
