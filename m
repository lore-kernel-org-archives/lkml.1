Return-Path: <linux-kernel-owner+w=401wt.eu-S1758842AbYAUNAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842AbYAUNAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 08:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYAUNAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 08:00:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:60090 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYAUNAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YGZtasDw1cXZyQoSbOkcQd9IMraEPSMLUG0MemAFCw2vO6RFfpPR8fMFmREPo8KXBfmjB7Ca1ryf8+9Ao2TVqedxIlAUIICf0yQRxJEkNAj/Ye+5Ju8WAYRUAhhwHbsxhfK7k9SkYzLX2GklWjR1f2WGoNWGGor4Cmz0WhcQ76g=
Message-ID: <ee3dc96c0801210500s51309dev71fb5e56e87cd6c3@mail.gmail.com>
Date: Mon, 21 Jan 2008 10:00:42 -0300
From: "Rafael Sisto" <rafael.sisto@gmail.com>
To: "Rafael Sisto" <rafael.sisto@gmail.com>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: new file in kernel.
In-Reply-To: <20080120012934.GE9896@lug-owl.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com>
	 <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr>
	 <ee3dc96c0801190608q33aee0aer133611a1fc392bb4@mail.gmail.com>
	 <Pine.LNX.4.64.0801191526200.27831@fbirervta.pbzchgretzou.qr>
	 <ee3dc96c0801190712v56bcfde5qa015888f2bcbde98@mail.gmail.com>
	 <20080120012934.GE9896@lug-owl.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to Thank everybody for the quick answers!!
I also want to apologise all the unnecessary noise done in the mailing
list, maybe it wasn't the right place to post (I must say it was worth
the posting). I got some nice ideas and advices...

Lastly, I would like to answer some questions, and discuss some points told.

Stefan, what you said:
"Why back the shared memory with a file?  Wouldn't a memory buffer suffice?"...
That was discarded at the beginning, because we didn't want to spend
kernel memory, so the user would have the freedom of asking as much
memory as he'd want. The fact is that we would be using IO on the
kernel, and it has been told, that it shouldn't be done...

Jan, our idea obviously wasn't that the user program used the syscalls
directly, instead he would use a library to ask for memory, attach,
etc (It wouldn't loose that much portability). Thanks for the book
suggestion.. I will try to read it!

Greetings, Rafael Sisto.






On Jan 19, 2008 10:29 PM, Jan-Benedict Glaw <jbglaw@lug-owl.de> wrote:
> On Sat, 2008-01-19 12:12:10 -0300, Rafael Sisto <rafael.sisto@gmail.com> wrote:
> > Dear Jan,
> >
> > The idea of the indirection is to make it transparent for the user.
> > The idea is to do almost the same as what IPC does. The user calls
> > "get", then "attach". In the "get" syscall I create a tmp file and
> > return some id. Then the user calls an "attach" syscall with the
> > returned id.
> >
> > The result is that he gets a shared memorymapped to his vma.
>
> So my understanding is that you want to get a "IPC shared memory for
> dummies" API. You're already willing to use custom-numbered system
> calls, requiring to recompile the Linux kernel, having to add these
> system calls to libc (or putting _syscallX macros into the
> application's code) and loosing all portability for the application
> using this API.
>
> My point of view is that this is a planed nightmare :)
>
> I'd suggest to dig into "Unix Network Programming, Volume 2.
> Interprocess Communications" and implement that API as a library
> instead of using a set of new kernel system calls. That way, the
> applications using it will use that API and only that. They won't
> require operatins system specific modifications afterwards. OTOH, this
> library will probably quite portable by itself and shouldn't need
> any kernel changes, independent of the underlying kernel.
>
> MfG, JBG
>
> --
>       Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
>  Signature of:                      http://perl.plover.com/Questions.html
>  the second  :
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iD8DBQFHkqP9Hb1edYOZ4bsRAtUzAKCKvKPIgc58hDSL4V1XXny2x6VBgACeNxGF
> nbkSbVGVuP1G6kOM91xrvn4=
> =XzNR
> -----END PGP SIGNATURE-----
>
>
