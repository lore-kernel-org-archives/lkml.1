Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZKDVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZKDVcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbZKDVcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:32:19 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43551 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177AbZKDVcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hr92Ee8z9slk82McoGT7PsqMlG/3ehk6IjKup/zHTeq5dYKzee06t9o2W5030HxU0J
         SmBxXYl4Bl8byu+NUOJiTHYIA+3vK3XquGa0ydJGup3LEKvmFWEA95h18F7hm5MWNHyc
         jdRUkUKFwuqhCJXRymT2JnwbXMAkStw5U4JyM=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
	 <20091104165407.1481bc29@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.64.0911041758420.9986@artax.karlin.mff.cuni.cz>
	 <200911041848.48721.tweek@tweek.dk>
	 <Pine.LNX.4.64.0911041901090.26209@artax.karlin.mff.cuni.cz>
	 <22108.1257364949@turing-police.cc.vt.edu>
	 <Pine.LNX.4.64.0911042104260.8785@artax.karlin.mff.cuni.cz>
	 <23950.1257367315@turing-police.cc.vt.edu>
	 <Pine.LNX.4.64.0911042144200.17832@artax.karlin.mff.cuni.cz>
Date: Wed, 4 Nov 2009 15:32:22 -0600
Message-ID: <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com>
Subject: Re: package managers [was: FatELF patches...]
From: kevin granade <kevin.granade@gmail.com>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Valdis.Kletnieks@vt.edu, Martin Nybo Andersen <tweek@tweek.dk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 3:11 PM, Mikulas Patocka
<mikulas@artax.karlin.mff.cuni.cz> wrote:
>> > > No, all they need to do is bump the .so version number.
>> >
>> > That's what Debian did. Obviously, I can extract the old library from the
>> > old package. But non-technical desktop user can't.
>>
>> But the non-technical user probably wouldn't have hand-compiled vim and links
>> either, so how would they get into that situation?
>
> Non-technical users won't hand-compile but they want third party software
> that doesn't come from the distribution. And package management system
> hates it. Truly. It is written with the assumption that everything
> installed is registered in the package database.
>
> Another example: I needed new binutils because it had some bugs fixed over
> standard Debian binutils. So I downloaded .tar.gz from ftp.gnu.org,
> compiled it, then issued a command to remove the old package, passed it a
> flag to ignore broken dependencies and then typed make install to install
> new binaries. --- guess what --- on any further invocation of dselect it
> complained that there are broken dependencies (the compiler needs
> binutils) and tried to install the old binutils package!
>
> Why is the package management so stupid? Why can't it check $PATH for "ld"
> and if there is one, don't try to install it again?
>
> After few hours, I resolved the issue by creating an empty "binutils"
> package and stuffing it into the database.
>
> Now, if I were not a programmer ... if I were an artist who needs the
> latest version of graphics software, if I were a musican who needs the
> latest version of audio software, if I were a gamer who needs the latest
> version of wine ... I'd be f'cked up. That's why I think that package
> management is an evil feature hurts desktop users. As a technical user, I
> somehow solve these quirks and install what I want, as a non-technical
> user, I wouldn't have a chance.

I think the important question here is what is is exactly that the
package manager *did* to break the app you are talking about?  Did it
keep the person who released the software from including the required
libraries?  Did it keep them from compiling it statically?  Did it
interfere with them building against LSB? No, it didn't do any of
these things, all it did was not be as up to date as you wanted it to
be, and not magically be able to discern that you've replaced one of
the most core packages in the system (which, by the way is most
definitely not something that %99.999 of users are going to try)

I'm of the opinion that the package manager IS the "killer app" for
Linux, and the main thing that makes it usable at all for the
less-technical users you seem to think it is driving off.  Is it
perfect?  of course not, particularly if you want to strike off on
your own and install things manually.  But the pain you're running
into when you do that isn't caused by the package manager, it's what
is left if you take the package manager away.

>
> Mikulas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
