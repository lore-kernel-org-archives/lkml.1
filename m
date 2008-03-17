Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYCQRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYCQRLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYCQRLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:11:06 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:19821 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbYCQRLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:11:05 -0400
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2008 13:11:05 EDT
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
From: spam@altium.nl (Dick Streefland)
Subject: 2.6.24.3: unexpected SIGTRAP in gdb
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <5ad2.47dea211.2cd38@altium.nl>
Date: Mon, 17 Mar 2008 16:53:37 -0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel version 2.6.24.3, I sometimes get an unexpected SIGTRAP
signal during the evaluation of a function call on the gdb command
line. This problem does not occur with kernel version 2.6.23.12
running on the same machine. Both gdb-6.4.90 and gdb-6.7.1 exhibit
this behavior.

I can reproduce the problem as follows:

$ cat > bug.c
int x;
int foo(void)
{
	return 42;
}
int main(int argc, char* argv[])
{
	x++;
	return 0;
}
^D
$ cat > bug.gdb
b main
r
s
p foo()
p foo()
^D
$ gcc -static -g -o bug bug.c
$ gdb -n -batch -x bug.gdb bug
Using host libthread_db library "/lib/tls/libthread_db.so.1".
Breakpoint 1 at 0x8048200: file bug.c, line 8.

Breakpoint 1, main () at bug.c:8
8               x++;
9               return 0;
$1 = 42

Program received signal SIGTRAP, Trace/breakpoint trap.
0x080481e9 in foo () at bug.c:3
3       {
/tmp/bug.gdb:5: Error in sourced command file:
The program being debugged was signaled while in a function called from GDB.
GDB remains in the frame where the signal was received.
To change this behavior use "set unwindonsignal on"
Evaluation of the expression containing the function (foo) will be abandoned.

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

