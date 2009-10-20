Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZJTSLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZJTSLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJTSLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:11:15 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44332 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZJTSLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uZdBoXymyIt6H262ZaPLqy0o31YRmcGBvV93rIfXBch7MLucmhEsyW0+uDRFY2gM0p
         wNVt20yCDvUiNuXQCRbJMOirV5qAAj9bk+dd80C1nifKBRjxiRstVEhpQgX1Cfz2l6f0
         JgxYf6c33Zb7UpO7o0tOBAdZBUcdzREoNmBJ0=
MIME-Version: 1.0
In-Reply-To: <20091020131744.GH10727@kernel.dk>
References: <200910192221.03805.czoccolo@gmail.com>
	 <20091020005446.GB10727@kernel.dk>
	 <4e5e476b0910200301w4ae2725ch37b81c1529bdcfec@mail.gmail.com>
	 <20091020131744.GH10727@kernel.dk>
Date: Tue, 20 Oct 2009 20:11:19 +0200
Message-ID: <4e5e476b0910201111l21ca6574qd5eb3ac2ab089052@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] cfq-iosched: adapt slice to number of processes 
	doing I/O
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 3:17 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> I do, personally it doesn't read anywhere near as naturally as a simple
> 'if'. And when you start doing x = a ? b : c ? d : e; I almost reach for
> the nearest expletive :-)
In this case, formatting it on multiple lines could help:
 a ? b :
   c ? d :
   e;
>
> And adding a local scope with {} and having 3-4 broken lines of
> multiplications, divisions (etc) inside max()/min() calls doesn't add to
> the readability in any positive way...

Ok, but min and max hide a lot of complexity for the corner cases.
Espressing those with plain ifs would be really a tough task.

>
>> To me, it seems a good way to achieve a different readability goal,
>> i.e. define the value of a variable in a single place, instead of
>> scattering it around on multiple lines.
>
> I prefer putting it elsewhere instead. So instead of doing:
>
>        foo_type bar = x(y) == BAZ ? a : b;
>
> you have
>
> get_foo_type(y)
> {
>        if (x(y) == BAZ)
>                return a;
>
>        return b;
> }
>
>        foo_type bar = get_foo_type(y);
>
> which is a lot more readable to me. Especially since you have to do the
> get_foo_type() operation in a lot of places.

Sounds good. I'll do in this way in next version.

>
>> It's not important for the patches per se, but I found odd (and it
>> caused me some headache while debugging) that in cfq_add_rq_rb the
>> fifo was still empty.
>> In the new form, the rq will be complete when added, while in the
>> previous, it still had some empty fields.
>
> Then keep it like it is, or do it as a separate patch. When you include
> it in a functionally changing patch like this, I'm assuming there must
> be a reason for that. And when it seems like there isn't, you wonder
> what is up.

I'm moving it in the preparation patch, that is not changing
functionality. There,. it makes more sense.

I'm going to send the revised series soon.

Corrado
>
> --
> Jens Axboe
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
