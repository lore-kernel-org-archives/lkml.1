Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbXCSTYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbXCSTYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXCSTYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:24:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43917 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbXCSTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:24:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, bryan.wu@analog.com,
       Robin Holt <holt@sgi.com>,
       "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, haoki@redhat.com,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: Move to unshared VMAs in NOMMU mode?
References: <Pine.LNX.4.64.0703152043290.24211@blonde.wat.veritas.com>
	<3378.1173204813@redhat.com>
	<Pine.LNX.4.64.0703051843030.10272@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0703021646050.13167@blonde.wat.veritas.com>
	<20070216165042.GB409@lnx-holt.americas.sgi.com>
	<45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com>
	<20368.1171638335@redhat.com> <18817.1171656543@redhat.com>
	<29317.1172931029@redhat.com> <12852.1173449522@redhat.com>
	<12838.1173998825@redhat.com>
Date: Mon, 19 Mar 2007 13:23:17 -0600
In-Reply-To: <12838.1173998825@redhat.com> (David Howells's message of "Thu,
	15 Mar 2007 22:47:05 +0000")
Message-ID: <m1wt1dvxzu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm just trying to digest this a little.

As I understand your description for non-shared mappings the VMAs are
per process.

For shared mappings you share in some sense the page cache.

My gut feel says just keep a vma per process of the regions the
process has and do the appropriate book keeping and all will be fine.

For shm_nattach it looks like you simply are not calling the
open/close methods on fork (because you have a shared pool of vmas).

Eric
