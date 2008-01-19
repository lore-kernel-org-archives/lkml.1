Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbYASOFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbYASOFX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYASOFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:05:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:23735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbYASOFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:05:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Au6/Tq4PbeNhRe0FQBAPSLzMrfuX9BrFk3VtDkpBw1Vw75vLyXKkjn11rB3Mt1DEMdu19b2W/y8JSnEKELSSfvntUVp8gEZEAhUmNFMYW7wx9LMmw9PkNaZBVdesAtB7k6snMTlijjSdEtFXxPq7uBxc/ka2kcZGr0anXZ6Ztr4=
Message-ID: <bcadbdf50801190605s212ebe26n3035d8664554f636@mail.gmail.com>
Date: Sat, 19 Jan 2008 15:05:05 +0100
From: "dAniel hAhler" <dhahler@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Regression with idle cpu cycle handling in 2.6.24 (compared to 2.6.22)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have BOINC running in the background with niceness 19.
With a 2.6.22 kernel, only idle cpu cycles get assigned to this process, as
expected.

But with the 2.6.24 kernel, the BOINC process gets at least about half of
all CPU cycles, even if there's another process (owned by another user)
requesting CPU cycles (e.g. "cat /dev/urandom > /dev/null")

This happens with the Ubuntu kernel (from Hardy) and the daily builds from
http://kernel-archive.buildserver.net/debian-kernel/ (where I've just tested
rc8 now).

It appears that every user (here "boinc" and my user) get the same portion
of the overall CPU cycles, regardless of the process niceness.

Is this expected behaviour?

I'm using an AMD64 3000+ processor. Please ask for additional information, if
you need it (e.g. kernel config).


TESTCASE:
$ cat /dev/urandom > /dev/null &
$ sudo -u another_user nice -n 19 python -c 'i = 0;
while 1:
  i += i
'

EXPECTED RESULT:
The niced process should get nearly no CPU cycles.

ACTUAL RESULT:
The niced process gets about half of the CPU cycles (according to "top").


The bug has been reported for Ubuntu on https://launchpad.net/bugs/177713


-- 
http://daniel.hahler.de/
