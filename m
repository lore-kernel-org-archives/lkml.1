Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZHLPqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZHLPqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZHLPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:46:14 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:47573 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZHLPqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Pc9ad90gl/nitCTBMO+eYUhQPipBhwX5EXgsIL2WwaUq8cPGy5cQBuZS/qxFbmcP9S
         OnsWD5h6z7vYRgfr1/hnG7JjDbRMY9Ey5YhCzFrzXBeCX9YIZSUafdiQTMMuUlE5tnag
         gfF3077Eqrfjbwef1jj0YZ8ueatkaTgM3MERY=
MIME-Version: 1.0
In-Reply-To: <200908121423.06403.npalix@diku.dk>
References: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com> 
	<Pine.LNX.4.64.0908120659001.32131@ask.diku.dk> <43e72e890908120045s6e94bd5es480bb4ef1a66597c@mail.gmail.com> 
	<200908121423.06403.npalix@diku.dk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Aug 2009 08:45:54 -0700
Message-ID: <43e72e890908120845k435e5838sf40e90dfd6869b7d@mail.gmail.com>
Subject: Re: Typedef removal tool
To: Nicolas Palix <npalix@diku.dk>
Cc: Joe Perches <joe@perches.com>, Julia Lawall <julia@diku.dk>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 5:23 AM, Nicolas Palix<npalix@diku.dk> wrote:
> On Wednesday 12 August 2009 09:45:35 Luis R. Rodriguez wrote:
>> On Tue, Aug 11, 2009 at 10:01 PM, Julia Lawall<julia@diku.dk> wrote:
>> > On Tue, 11 Aug 2009, Luis R. Rodriguez wrote:
>> >
>> >> Anyone know if there is a typedef removal tool? When porting drivers
>> >> this needs to be done quite often.
>> >>
>> >> FWIW I've started porting some driver and have come across some tools,
>> >> or written my own scripts, which have helped. Using spatch to port a
>> >> driver was such a tool I explored. I think I'll try to put together
>> >> some info on the driver project wiki for this. typdef removal tool
>> >> would still be neat.
>> >
>> > Nicolas Palix (in CC) did a bit of work on this recently using Coccinelle,
>> > but the problem is that simply removing the typedef is not enough, one has
>> > to come up with a name that is within the spirit of the names used in
>> > Linux, or perhaps recognize that the structure in question already exists
>> > in a more general form in the kernel an thus the declaration should be
>> > removed completely.
>> >
>> > Someone else made a dedicated tool using a dictionary of the old and new
>> > names that at least partially addresses these problems.  Nicolas knows who
>> > that person is.
>>
>> Sounds like a very proper way to do this.
>>
>> I wrote something not-so-proper and simple based on Joe's work that
>> just replaces a specified typedef name with one the user specifies.
>> Should do it for simple porting where you do not have to prove
>> correctness and avoid namespace collisions.
>>
>
> We have done this for the new Hyper-V drivers.
> Joe Perches (CC) proposes a shell and perl solution (cvt_typedef_to_struct.bash)
> with the typedefs file dictionary, attached to this email.
>
> I have modified my typedef_str.cocci file to use his dictionary.
> This cocci file generates a cocci file per typedef to remove.
> The generated files could be applied with the modified version
> of Joe's shell script or by hand, at your convenience.

Great thanks Nicholas! I'll play with these.

BTW I was under the impression spatch wouldn't touch header files or
dive in to untangle macros. Is that incorrect? Would the cocci files
allow spatch to not only change typdef usages with simple struct uses
but also redefine a typedef declaration to a simple struct definition
through header files? For upstream work I don't expect as much macro
mess as you would with typical vendor drivers. For drivers which do
need to get ported I do expect an tangling web of macro mess one may
need to put up with at times.

  Luis
