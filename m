Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYGMUyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYGMUyB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYGMUxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:53:52 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:46797 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYGMUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tm3gvBHf/Hg4Z0zMMgA2JzMK49yFU2SoS1nDHKHZ3dYCDmCfZZ67Qve4TcDYPmLTE4
         oIVAeoqzD/K3+tMwi+ak5/Iwyqn+mZ/yfazumL9BGfoKu8M6/L3whH0G3nE1Fy2z1L6f
         5VnSzKu34JFhq0sug+PAjdDyE99QyvKTzwYy0=
Message-ID: <dd18b0c30807131353l3608ab5l248ae799994cc58d@mail.gmail.com>
Date: Sun, 13 Jul 2008 20:53:49 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <Pine.LNX.4.64.0807132122001.16625@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
	 <dd18b0c30807131234n5edf3e1dt93022a45d427b1fd@mail.gmail.com>
	 <19f34abd0807131252k5499e6e2sc93f8cd70f488b7e@mail.gmail.com>
	 <Pine.LNX.4.64.0807132122001.16625@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 8:27 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Sun, 13 Jul 2008, Vegard Nossum wrote:
>> On Sun, Jul 13, 2008 at 9:34 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> > On Sun, Jul 13, 2008 at 6:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> This message has been generated automatically as a part of a report
>> >> of recent regressions.
>> >>
>> >> The following bug entry is on the current list of known regressions
>> >> from 2.6.25.  Please verify if it still should be listed.
>> >>
>> >>
>> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
>> >> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
>> >> Submitter       : Justin Mattock <justinmattock@gmail.com>
>> >> Date            : 2008-05-16 6:17 (59 days old)
>> >> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>> >>                  http://lkml.org/lkml/2008/5/18/168
>> >>                  http://lkml.org/lkml/2008/5/25/195
>> >> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>> >>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>>
>> I didn't follow the discussion, but I may contribute the following information:
>>
>> This message first appears in my logs on May 16. That was with kernel
>> version 2.6.24.5-85.fc8. The kernel I used before that was
>> 2.6.24.4-64.fc8 (May 3). My logs go back to November 8
>> (2.6.23.1-42.fc8). So we can hardly consider this a regression since
>> 2.6.25, but rather one since 2.6.24?
>>
>> (I'll also note that this message appears quite infrequently here.
>> Only 42 times in 219 boot-ups. So it would be hard to bisect, but I'm
>> guessing the error was introduced somewhere between 2.6.24.4 and
>> 2.6.24.5.)
>
> You're comparing against Fedora kernels, which often contain
> patches which haven't got into mainline yet.  As in this case.
> Unless it used to be assembled from separate pieces, there was
> no "GPE storm detected" message in 2.6.24.N or 2.6.25.N: it was
> added in 2.6.26-rc1.
>
> I sometimes see it too, on a Fujitsu-Siemens laptop.
>
> Hugh
>

Hello;
What I've been using is acpi_osi=Darwin so I don't have to take the
gpe storm detector mechanism out of ec.c
The two areas of interest are when not setting a boot option this
message is triggered by too many
interrupts with BAT0 i.g. /sys/firmware/acpi/interrupts "gpe17 on a
macbook2,2",
Now when using the Darwin option, the interrupts are very little, but
at the cost of loosing any battery info
but I am receiving a reaction with pommed i.g. unplugging the A/C
adapter does dim the screen.
Also I'm not sure if the smart battery was designed for the macbook,
but when using Darwin option, my system will
freeze upon booting(as a note alexy gave me some patches to test on
monday, but still was unable to load the module)
overall from my perspective; trying to tweak the BAT0 mechanism with
it's interrupts could fix this, and/or
port the sbs module to be used with the Darwin option with interrupts
under control, could also be another option,
or have all two working this way the user can decide what they prefferer.
 Personally tweaking the interrupts with BAT0 seems to be more of an
easier solution,
but then again could cause other problems elsewhere.

-- 
Justin P. Mattock
