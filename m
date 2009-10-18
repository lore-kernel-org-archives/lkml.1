Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbZJROp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbZJROp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 10:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbZJROp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 10:45:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54365 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZJROp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 10:45:57 -0400
Date: Sun, 18 Oct 2009 16:46:01 +0200
From: Thomas Wolff <towo@towo.net>
To: linux-kernel@vger.kernel.org
Subject: 3 errors related to console modes
Message-Id: <0MErMM-1N19Zs1mEU-00GSkX@mrelayeu.kundenserver.de>
X-Provags-ID: V01U2FsdGVkX1++AdgfUzETKbZZgXwhFwnq+GahNMH3Blb6E2n
 IeEXZvIT8NkxoPhBzrByUWoNrRNa6JKTCHSFXDv2HQoAtHroAj
 XlJxNSrZBy7qw9X9kz5Qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The manual page describes two graphics character set modes:
* VT100 line drawing graphics, triggered with ESC ( 0 or ESC ) 0 ^N
* VGA block graphics, triggered with ESC [ 11 m
Both graphics modes do not work in UTF-8 mode.

Termcap/Terminfo entries smacs (as) and rmacs (ae) are wrong. The codes 
switch graphics mode but not according to VT100 but rather to 
"native PC VGA" mode. The correct entries to give these codes would be 
smpch (S2) and rmpch (S3).
VT100 graphics works as described in "man console_codes", so the entries 
need to be fixed accordingly, in either of two ways:
1) smacs=\E(0:rmacs=\E(B (like the xterm entry)
2) with an additional entry for enacs (eA):
   smacs=^N:rmacs=^O:enacs=\E)0

In the manual page: In text section "MOUSE TRACKING", mouse tracking 
mode reset code is said to be ESC [ 1000 l, its correct value, also 
listed above, is ESC [ ? 1000 l

Thomas
