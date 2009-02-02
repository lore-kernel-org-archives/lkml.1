Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZBBTFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZBBTFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 14:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZBBTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 14:05:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:46017 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZBBTFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 14:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wAnx85uj+9rsbv0HHgqOnGkquWi9eDlpYRsi212T1v2qXCVL1rIKlldAbteBXtwTTZ
         snTsffGi8PKl0kASIHMRzcZ4eMzLdCsclsff5CkNrkAPBcw/G6NDSdTJ4ScupEh9W020
         V5DZ4lPs+CtQwLuIWyUppTe3rF0w4WtAwymYg=
MIME-Version: 1.0
Date: Mon, 2 Feb 2009 11:05:06 -0800
Message-ID: <438397970902021105x542ad227xe78005fa2a3432fb@mail.gmail.com>
Subject: kgdb break point problem on 2.6.28.2
From: Kallol Biswas <nucleodyne@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I have setup kgdb over serial port and installed a few kernel modules.
The module symbol has been added with the command:

add-symbol-file  <module.ko file> <start adddress from /proc/modules>
(gdb) add-symbol-file /data/cxgb3toe-1.2/src/cxgb3/cxgb3.ko 0xf83dc000
add symbol table from file "/data/cxgb3toe-1.2/src/cxgb3/cxgb3.ko" at
	.text_addr = 0xf83dc000
(gdb) rb cxgb3_.*
Breakpoint 1 at 0xf83e1573: file
/data/cxgb3toe-1.2/src/cxgb3/cxgb3_main.c, line 897.
int cxgb3_filter_toe_mode(struct adapter *, int);
Breakpoint 2 at 0x24: file /data/cxgb3toe-1.2/src/cxgb3/cxgb3_main.c, line 4778.
static void cxgb3_cleanup_module(void);
Breakpoint 3 at 0x1c70: file
/data/cxgb3toe-1.2/src/cxgb3/cxgb3_main.c, line 4752.

It seems that all the symbols are visible, can list and put break
points in functions.

However, if I hit continue, and when execution hits breakpoints
following messages
are displayed:

(gdb) c
Warning:
Cannot insert breakpoint 2.
Error accessing memory address 0x24: Unknown error 18446744073709551615.
Cannot insert breakpoint 3.
Error accessing memory address 0x1c70: Unknown error 18446744073709551615.
Cannot insert breakpoint 5.
Error accessing memory address 0xdb0: Unknown error 18446744073709551615.
Cannot insert breakpoint 6.
Error accessing memory address 0x2095: Unknown error 18446744073709551615.
Cannot insert breakpoint 15.
Error accessing memory address 0x5a: Unknown error 18446744073709551615.
Cannot insert breakpoint 16.
Error accessing memory address 0x1cd2: Unknown error 18446744073709551615.


The ddd version is 3.3.10 and gdb version is 6.8.

Any idea what mistake I have made?
