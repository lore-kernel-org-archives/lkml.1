Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZGVKlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZGVKlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZGVKlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:41:04 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:35713 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZGVKlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:41:02 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2009 06:41:01 EDT
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
X-Newsreader: knews 1.0b.1
Reply-To: dick.streefland@altium.nl (Dick Streefland)
Organization: Altium BV
X-Face: "`*@3nW;mP[=Z(!`?W;}cn~3M5O_/vMjX&Pe!o7y?xi@;wnA&Tvx&kjv'N\P&&5Xqf{2CaT 9HXfUFg}Y/TT^?G1j26Qr[TZY%v-1A<3?zpTYD5E759Q?lEoR*U1oj[.9\yg_o.~O.$wj:t(B+Q_?D XX57?U,#b,iM$[zX'I(!'VCQM)N)x~knSj>M*@l}y9(tK\rYwdv%~+&*jV"epphm>|q~?ys:g:K#R" 2PuAzy-N9cKM<Ml/%yPQxpq"Ttm{GzBn-*:;619QM2HLuRX4]~361+,[uFp6f"JF5R`y
References: <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain> <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain> <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl> <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl>
From: dick.streefland@altium.nl (Dick Streefland)
Subject: Re: Linux 2.6.27.27
Content-Type: text/plain; charset=us-ascii
NNTP-Posting-Host: 172.17.1.66
Message-ID: <2419.4a66eadd.ced9e@altium.nl>
Date: Wed, 22 Jul 2009 10:33:01 -0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Oledzki <olel@ans.pl> wrote:
| Here is a diff between a good and a bad kernel:
| 
| -edid_checksum debug: csum=0, all_null=255, err=1
| -edid_checksum debug: csum=0, all_null=255, err=1
| -Console: switching to colour frame buffer device 128x48
| +edid_checksum debug: csum=6400, all_null=255, err=0
| +Console: switching to colour frame buffer device 80x30
| 
| In the good one the function is called twice and it returns err=1 (==OK). 
| In the bad kernel it returns 0 because csum!=0x00 (==6400).

Linus accidentally dropped the "char" from the declaration of "csum" and
"all_null":

> -	unsigned char i, csum = 0, all_null = 0;
> -	int err = 0, fix = check_edid(edid);
> +	unsigned csum = 0, all_null = 0;
> +	int i, err = 0, fix = check_edid(edid);

-- 
Dick Streefland                      ////                      Altium BV
dick.streefland@altium.nl           (@ @)          http://www.altium.com
--------------------------------oOO--(_)--OOo---------------------------

