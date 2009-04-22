Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZDVOMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZDVOMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZDVOMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:12:10 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:63770 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZDVOMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=b6n/SAEqY1tM1BwvgrU9PbSTvGOQZONOzkxdfzvXWG/Xye8tWWZqcayfa/1b8zeHod
         owzZopU2klrugjGADvOh8wKeTvpc9RIBqyvJeVB6b145YBrTsFzCQos8k9jA1FrZx6a9
         L32S1RzTpMyTFWKpR/mnCQY/yhxAKScsuDCNE=
MIME-Version: 1.0
Date: Wed, 22 Apr 2009 18:12:07 +0400
Message-ID: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
Subject: Idea: Feature information / extensions dispatcher syscall.
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

System calls is a very convenient way to talk to modules. But when some modules
used locally (e.g. in one organization only) it will be to impractical
to reserve system
call number in linux kernel source for that feature forever. Usually
first free syscall
number is used. But when new system call is introduced in official kernel,
one need to rewrite all modules and libraries, since first free
syscall number is increased.

I suggest to reserve one system call to provide information about
other system calls.
This can help to build system call independent programs.

That informational / dispatcher system call can take some identifier
as argument (e.g. GUID)
and return some information about asked extension (e.g. syscall number
for that extension).

So libraries that use some additional functionality upon first call of
extension function
will ask kernel (via informational syscall), what is the number of
feature's syscall, and will
use it later directly.

Also can be useful to reserve some system call number (e.g. 8) for
such extensions,
so extension modules can use first unused number of this set.

This allow to use system calls in any extension modules without need to reserve
syscall number in kernel source and allow binaries to run correctly on
any kernel
(where that extension feature can have another syscall number).

What do you think?
