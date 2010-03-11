Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab0CKLC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:02:58 -0500
Received: from web110312.mail.gq1.yahoo.com ([67.195.8.212]:32769 "HELO
	web110312.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756924Ab0CKLC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:02:57 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 06:02:57 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=WoGdlxiad/of5iRzwmoZLjLpIKK1c5E8Z3BL5wil0xSVHva8bQUSyVSwlp2SMIfdfHNMuOcsXYpu6odCyMwQlsth6f9UfoKvKNDwBlDMx7gy3eE5tYEPoBqfX4kX16xL70c+9uQ+3iecIyNZcAbiUQRyFUr1oApPGr4vU93HR3I=;
Message-ID: <812529.11018.qm@web110312.mail.gq1.yahoo.com>
X-YMail-OSG: TIiGpKYVM1lefBTtQ2byJSjCKjMWYAKEBKc8r9jWOqx9xyL
 oNkSwbvsnAy_wLLozB5fN56D3MgaDP5HP029AqgujIKRYqC3ctf.3a5_Rx8R
 46QQHgRVyXLzP97Ec7BHyEcHp163bUgPP.K.2cyVm4LmgVAZICJhAQlPw8Wd
 4_dy_6WmAOdwItgXY8rmy.z3DIA1j0tE7jAIvALsENMReXEaA9EGKES_VMmK
 AUAoaegLNNP4bQxhO_6TnmXy_qu6stbuLGHtj0KFrGFNGbTK6pMvArQoW59R
 6yZDvbItPj9Bo28K_v47KA0th4E3SzS2E8H5Bnf35xvhnzGYOy29ur7uK9vP
 spgV7muzOXDEJGtiYJSDWeVTttTWnEQ--
X-Mailer: YahooMailClassic/9.2.12 YahooMailWebService/0.8.100.260964
Date: Thu, 11 Mar 2010 02:56:16 -0800 (PST)
From: Valery Reznic <valery_reznic@yahoo.com>
Subject: execve for script don't return ENOEXEC, bug ?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I Have following to scripts:

a.sh
#!/bin/sh
echo "It's a.sh

and b.sh:
#! ./b.sh
echo "It's b.sh"

As per execve man page, script interpreter should not be script itself.
When I run it on my Fedora 8 x86_64 box (with stock kernel, never updated)
under strace I got following:

strace -f -e execve  setarch x86_64  ./b.sh 
execve("/usr/bin/setarch", ["setarch", "x86_64", "./b.sh"], [/* 23 vars */]) = 0
execve("./b.sh", ["./b.sh"], [/* 23 vars */]) = -1 ENOEXEC (Exec format error)
execve("/bin/sh", ["/bin/sh", "./b.sh"], [/* 23 vars */]) = 0
It's b.sh

I.e execve failed as it should

When I run same scripts on Fedora 12 x86_64 box with stock kernel 2.6.31.5-127.fc12.x86_64 I got following:

strace -f -e execve setarch i386  ./b.sh 
execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"], [/* 41 vars */]) = 0
execve("./b.sh", ["./b.sh"], [/* 41 vars */]) = 0
It's a.sh

I.e execve succeeded, instead of failing with ENOEXEC

Regards,
Valery.

P.S. I am not subscribed to this list, so please CC me






      
