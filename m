Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbZFYPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbZFYPi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZFYPiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:38:20 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:40392 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZFYPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=UOPkkn8TwKzxMGgRyQDLqDiRaI/326xSDqbW/n9A9YMYMIukwnaWEQC+q+hD5cNFed
         Fcdl077816YxG2DvbJih+fi1pJc8k9CKrqxnbZ3PgKo1mTRE8KU1abRjY/sjUu6I9SpS
         PmyMBl9CCRDSZgHqWH9LpW+SHT4ixb7+FMBnY=
MIME-Version: 1.0
Date: Thu, 25 Jun 2009 11:38:22 -0400
X-Google-Sender-Auth: bc8b9c90c7b39830
Message-ID: <76366b180906250838x36a82aaexe89caa2db48d4386@mail.gmail.com>
Subject: Realistically possible to run a IA64 big-endian process using PSR.be 
	register?
From: Andrew Paprocki <andrew@ishiboo.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm just wondering if anyone has tried to run a long-lived big-endian
process on IA64 by setting the PSR.be bit from user space. As an
example, it appears that OpenSSL md5 code uses this register to switch
endian modes at runtime, but it does so only for some computation code
that doesn't make any syscalls.

According to http://www.kernel.org/doc/Documentation/ia64/fsys.txt:
"PSR.be
        Cleared when entering fsys-mode.  A srlz.d instruction is used
        to ensure the CPU is in little-endian mode before the first
        load/store instruction is executed.  PSR.be is normally NOT
        restored upon return from an fsys-mode handler.  In other
        words, user-level code must not rely on PSR.be being preserved
        across a system call."

Can the library calls be wrapped to ensure any data handling is
performed and the bit is set after they return?

Disclaimer: Please don't hit me. :) I understand this is ugly, but I'm
just looking to see if we can experiment with this and if anyone has
attempted it before. The code can not be reliably made endian neutral
in any reasonable time frame.

Thanks,
-Andrew
