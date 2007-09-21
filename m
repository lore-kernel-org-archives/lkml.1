Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbXIUN3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbXIUN3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbXIUN3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:29:21 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:19749 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758846AbXIUN3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:29:20 -0400
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <20070920195844.GA1805@martell.zuzino.mipt.ru> <20070920195844.GA1805@martell.zuzino.mipt.ru> <200709201702.08126.rob@landley.net>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: [Announce] Linux-tiny project revival
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <2735.46f3c72e.5c662@altium.nl>
Date: Fri, 21 Sep 2007 13:29:18 -0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rob@landley.net> wrote:
| I'm proposing allowing an ignore_loglevel to remove the unused messages at 
| compile time so they don't take up space.  Doing that requires the levels to 
| be integers so they can be compared with < or >, and the remaining changes 
| follow logically.  (To me, anyway...)

Gcc seems to be smart enough to do contant folding on string
subscripts, so you don't need to change any of the printk()s.
Here is what I mean:

#include <stdio.h>

#define	actual_printk	printf

#define KERN_ERR        "<3>"   /* error conditions                     */
#define KERN_WARNING    "<4>"   /* warning conditions                   */
#define KERN_NOTICE     "<5>"   /* normal but significant condition     */

#define printk(str, ...) \
  do { \
    if ((str)[0] != '<' || (str)[1] < '5') \
      actual_printk((str), __VA_ARGS__); \
  } while(0);

int main(void)
{
	printk(KERN_ERR "error %d\n", 1);
	printk(KERN_WARNING "warning %d\n", 2);
	printk(KERN_NOTICE "notice %d\n", 3);
	printk("no level %d\n", 4);
	return 0;
}

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

