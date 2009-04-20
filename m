Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZDTXos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZDTXos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 19:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZDTXok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 19:44:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36120 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZDTXoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 19:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wD/QpQLbuZfrD3slTT5+48g6xZn7Nphx3IzTiaAxwKqFemS60MFfJ7BgPE1Ofax/ns
         hGbqogHN5zu6Hl6jyX9cg3fhvAz4b8l/J0WGU+QzZ6SIjXwmwoPlPO1iJBkpzdgs7bFu
         m/StfZA7na0B903k0b/WgxYE1cr4O2/8wnlhA=
MIME-Version: 1.0
Date: Tue, 21 Apr 2009 01:44:36 +0200
Message-ID: <2d05c4580904201644n58160449n2e917cbac096ceeb@mail.gmail.com>
Subject: Address of .globl _start
From: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have compiled test.s (bellow) with 'as' compiler:

-------------------------------------------------
.section .data

.globl var
var:
.long 10

.section .text

.globl _start
_start:
 movl $_start, %ebx
 jmp loop_exit

loop_exit:
  movl $1, %eax             #1 is the exit() syscall
  int $0x80

-------------------------------------------------
and got output with echo $? (reads %ebx register)
116

After that I compiled test.s (bellow) with 'as' compiler:

-------------------------------------------------
.section .data

.globl var
var:
.long 10

.section .text

.globl _start
_start:
 movl _start, %ebx
 jmp loop_exit

loop_exit:
  movl $1, %eax             #1 is the exit() syscall
  int $0x80

-------------------------------------------------
and got output with echo $? (reads %ebx register)
139

After that I compiled test.s (bellow) with 'as' compiler:

-------------------------------------------------
.section .data

.globl var
var:
.long 10

.section .text

.globl _start
_start:
 movl var, %ebx
 jmp loop_exit

loop_exit:
  movl $1, %eax             #1 is the exit() syscall
  int $0x80

-------------------------------------------------
and got output with echo $? (reads %ebx register)
10

After that I compiled test.s (bellow) with 'as' compiler:

-------------------------------------------------
.section .data

.globl var
var:
.long 10

.section .text

.globl _start
_start:
 movl $var, %ebx
 jmp loop_exit

loop_exit:
  movl $1, %eax             #1 is the exit() syscall
  int $0x80

-------------------------------------------------
and got output with echo $? (reads %ebx register)
132

So my question is, what these numbers mean ? From which
point in memory they are counted from ? From this I can conclude
that value for "movl _start, %ebx" is always 139 and it can be on
various addresses. Is this means that beginning of 'as' assembly program is
signed with value 139 ???

thanks,

Dragoslav Zaric,
[Programmer; M Sc Astrophysics]
