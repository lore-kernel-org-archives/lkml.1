Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbXHBNBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbXHBNBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbXHBNBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:01:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:5251 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbXHBNBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:01:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IItnU8VYN/QKvjSui5OVJTYvuhaoDUH488D8to5KAYEktNo9W7JOrxyYOJiJEfPu8eqH/+L5DyHHGLgU0Ljzzujx9S4UbVojrn2TP0bKpXBEG8p8inltOinkNGrFe1kL/GK27tcBdjgKG4sBILnZmyQW3eyCmz03b8ZEJX8paF8=
Message-ID: <5a4c581d0708020601i23ce309rd0e8459ca57caa4d@mail.gmail.com>
Date: Thu, 2 Aug 2007 15:01:30 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Matthew Marshall" <matthew@matthewmarshall.org>
Subject: Re: Touchpad loses sync with ACPI on.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200708020021.32260.matthew@matthewmarshall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708020021.32260.matthew@matthewmarshall.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/07, Matthew Marshall <matthew@matthewmarshall.org> wrote:
> I am having a problem with the touchpad and pointer stick on my HP compaq
> nc6000 laptop.  It only happens when using ACPI.
>
> Both pointing devices work for a while, but eventually start to 'stick'.  The
> cursor won't move for about a second, and then it jerks all over the screen,
> clicking.
>
> This problem gradually increases in frequency, until eventually neither device
> works at all.  Even cat'ing the respective /dev/input/event* device doesn't
> return anything, and I have to shut down or suspend the computer for
> about 15 minutes before it will work again.  (simply rebooting doesn't fix
> it.)  (Actually, it sometimes works if I press down REALLY hard... perhaps
> that's due to some sensitivity threshold being automatically adjusted?)
>
> Everything works perfectly if I boot with acpi=off.
>
> (I also left Windows open all day once, and it didn't happen there either.)
>
> I'm using kubuntu, and have tested it with kernel 2.6.20, 2.6.22.1, and
> 2.6.23-rc1.
>
> When the problem happens, I get lines like this from dmesg:
>
> psmouse.c: TouchPad at isa0060/serio4/input0 lost sync at byte 1
>
> or sometimes like this:
>
> psmouse.c: TouchPad at isa0060/serio4/input0 lost synchronization, throwing 4
> bytes away.
>
>
> From Google I have found a few other similar reports.  For one person this
> seems to happen under load.  For me, it sometimes seems to happen right when
> I start to compile or something, but it will also happen when I boot up the
> computer and don't even touch it.  (literally: I'll come back in a half an
> hour and the TP doesn't work.)
>
> Someone else seemed to have the problem from reading ACPI states.  I have not
> been able to find any correlation in this respect.  I booted up without the
> battery panel applet and without starting acpid, and it still started
> hiccuping after 5 minutes.
>
> There seems to be no correlation between how much I use it and how long it
> lasts.  Sometimes I can be using it constantly and it lasts an hour.
> Sometimes I barely touch it and it lasts only 10 minutes.
>
> I'm attaching the output of dmesg, lshw, lsmod and lspci.
>
> So, what more can I do?  Is there any more information I can provide?  Are
> there any patches I can try?  I'm willing to help out any way I can.
>
> Thanks for reading,
> Matthew Marshall
>
> P.S. I'm not subscribed, so please CC any replies.
>
> P.P.S. Sometimes it seems to be able to read my mind... Just when I think "wow
> it's lasting a long time!" it will freeze up within two seconds.  I
> understand that this might be hard for others to reproduce.

I had a total of three occurrences of a stuck touchpad on
 my Dell D610 since upgrading to Fedora 7, with custom
 kernels (FC6 was used up to 2.6.22-rc7-git2, never saw
 the issue):

[root@sandman ~]# grep -i psmouse /var/log/messages.1
/var/log/messages /var/log/messages.1:Jul 25 22:53:12 sandman kernel:
psmouse.c: GlidePoint at isa0060/serio1/input0 lost synchronization,
throwing 3 bytes away.
/var/log/messages.1:Jul 25 22:53:13 sandman kernel: psmouse.c: resync
failed, issuing reconnect request
/var/log/messages.1:Jul 27 10:43:39 sandman kernel: psmouse.c:
GlidePoint at isa0060/serio1/input0 lost synchronization, throwing 3
bytes away.
/var/log/messages.1:Jul 27 10:43:40 sandman kernel: psmouse.c: resync
failed, issuing reconnect request
/var/log/messages:Jul 30 14:51:20 sandman kernel: psmouse.c:
GlidePoint at isa0060/serio1/input0 lost synchronization, throwing 3
bytes away.
/var/log/messages:Jul 30 14:51:21 sandman kernel: psmouse.c: resync
failed, issuing reconnect request

I always use the touchpad and never the stick, and
 actually found out that when the touchpad stops working
 with the cursor disappearing, it's a good workaround to
 move the stick to get the cursor back (I assume moving
 the stick is what actually causes the above messages).

--alessandro

 "Did you get married but forgot to get divorced ?"

     (Danny and Dusty, 'The Good Old Days')
