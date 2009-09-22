Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZIVQzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZIVQzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZIVQzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:55:47 -0400
Received: from mail-yw0-f188.google.com ([209.85.211.188]:55169 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbZIVQzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type:content-transfer-encoding;
        b=q4hu5qgIdLXLo8Invfk5HCcxotv+bTJqoqvUrVpIJ+6S24SPbRVxHlPZuVjsAaPJwb
         OpvQyrfcth1Xfgj0YiZkUkRMB6xI74WGIIWTpquTQwlnsmqQo7z1DMauNCWhfdN2K8Tr
         /puOR1bxKN7xa0J4Nzy2/R/u/Nzsn0uGF5mYA=
MIME-Version: 1.0
From: pradeep hettiarachchi <pradeepmh@wayne.edu>
Date: Tue, 22 Sep 2009 12:30:34 -0400
X-Google-Sender-Auth: 90b488938531f225
Message-ID: <8fe204b0909220930t13db248cw8f9a8da7db4a4927@mail.gmail.com>
Subject: Intel Local APIC behavior on low frequencies
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here’s a description of my problem. It would be great if you can find
some info on this matter.



I need to find some information about local APIC and CPU frequency
scaling behavior.  Currently I am modifying  the Linux kernel for my
research, which involves studying a custom job scheduler I am
developing at different CPU frequencies.  As we know, if the kernel
works in tick-less mode (and in hi resolution mode) it uses the local
APIC as a clock event device and as the clock tick device.



My working environment is: Linux vanilla kernel 2.6.24, Intel core 2
Quad Q6600, Intel core 2 duo T6500 processors. Gcc compiler and the
tool chain.

The information I am trying to find is:

1) I want to find-out the tick count(say for a 100 ms period) of the
local APIC when the CPU operates at different operating frequencies.
When I study this matter, I found that the local APIC does not tick
(does not work accurately) reliably as the clock frequency is varied.
It works accurately in the maximum frequency of the system. Do you
know any reason for that? or it is the way it operates?(is that
normal?)

(my observation: when I count the LAPIC tick count for the maximum CPU
frequency, it matches with the number of ticks that the system
generates at the time of the initial LAPIC calibration, which happens
at the very beginning of the kernel initialization; however when I try
to count the number of ticks with scaled frequencies, the LAPIC
"current counter" difference is very less, some times less than 100
for 100 ms, which should not be true.)

I don't have good reason to think that, some other task re-programs
the LAPIC: I set the LAPIC "initial counter" to a huge value, further
I assume when the system works in hi resolution mode, the re-program
happens from the LAPIC handler "hrtimer_interrupt" which I replace
with a dummy handler.

Thank you in advance.

-Pradeep
