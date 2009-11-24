Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZKXAUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZKXAUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZKXAUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:20:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:8459 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZKXAUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:20:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aSFvIk/QsvE4iYGu4YaI/JuxTyjKzDUWiflG4HX+Di4LbdG/Z1fyTHSc3gQhJXxEMQ
         kpQaw4yOQYxV+3kbg1rGuWxHBr3eQNb3qBDlzaqBFth5gEv3Xm30QZroShbsT+1F0Ojp
         N1RlfWqK7cO6zWG0EsqJGrihUXAJcmHmQm5r8=
MIME-Version: 1.0
Date: Mon, 23 Nov 2009 19:20:26 -0500
Message-ID: <525c5a6c0911231620u6d23810fu9fed3605617fe421@mail.gmail.com>
Subject: Toshiba Satellite ACPI problems
From: Mike Smith <scgtrp@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a brand new Satellite L505D-S5983 which I'm trying to install
Linux on. Whenever I boot a Linux kernel on it with no special
parameters it enters an in(de)finite loop dumping messages like this:

ACPI Error (uteval-0313): Return object type is incorrect
[\_SB_.HSB1._STA] (Node ffff8800af8121a0), AE_TYPE
ACPI Error: Type returned from _STA was incorrect: Device, expected
Btypes: 1 20090521 uteval-319
ACPI Error (psargs-0359): [DR ] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.VALZ._STA] (Node ffff8800af812540), AE_NOT_FOUND
ACPI Error: Found unknown opcode 39 at AML address ffffc900000132cd
offset 0, ignoring 20090521 psloop-137
[...]

If I boot with acpi=noirq these messages only continue for a few
seconds, although they cause a couple of initscripts to hang later on.
With ACPI fully enabled they keep appearing forever and the system
doesn't finish booting. With acpi=off they don't appear at all (but
the fan stays at low speed and the laptop gets quite hot if run for
more than a few minutes).

I've found only one other mention of this problem on the internet
(http://ubuntuforums.org/showthread.php?p=8358864#post8358864) from
someone with the same laptop as mine, but there was no working fix
posted to that thread beyond completely disabling ACPI. More research
told me that there used to be a way of fixing up the DSDT and having
it loaded from the initrd but the new policy is to just ask the
manufacturer to fix it and the kernel developers to work around it,
so... here it is. (Angry emails to Toshiba and Best Buy pending.)

Full dmesg output can be found at http://slexy.org/view/s25zU08AKJ
(By the way, what's the correct way to include dmesg output in a lkml
message if you don't know for sure which parts are relevant? Dumping
all 50k or so of it into the email seems like the wrong thing to
do...)
