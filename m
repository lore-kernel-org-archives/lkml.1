Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbXI1IXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbXI1IXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbXI1IWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:22:50 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:4086 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756216AbXI1IWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:22:48 -0400
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <19f34abd0709271418l471cf7b9gf24161190772fac@mail.gmail.com>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: [RFC] New kernel-message logging API (take 2)
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <122e.46fcb9d3.ac322@altium.nl>
Date: Fri, 28 Sep 2007 08:22:43 -0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Vegard Nossum" <vegard.nossum@gmail.com> wrote:
|   It should be possible to optimize out multi-line (block) entries
| based on log-level filtering even though the log-level is only given
| in the first call (the initializer). It may take the shape of an
| if-block that spans several macros. This is not very elegant or robust
| if the macros are used incorrectly, however. Aborting a message can
| also be hard this way (since the abort would usually appear inside an
| if-statement that tests for some abnormal condition, thus appear in a
| different block, and thoroughly mess up the bracket order).
| 
| Example: {
| 	#define kprint_block_init(block, loglevel)		\
| 		if(loglevel > CONFIG_KPRINT_LOGLEVEL_MAX) {	\
| 			kprint_real_block_init(block, loglevel);
| 
| 	#define kprint_block(block, fmt, ...)			\
| 		kprint_real_block(block, fmt, ## __VA_ARGS__);
| 
| 	#define kprint_block_flush(block)			\
| 			kprint_real_block_flush(block);		\
| 		}

As you point out yourself, this is not very elegant or robust. In fact,
it is very dangerous. Why not simply pass the loglevel to each macro?

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

