Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZLOMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZLOMOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 07:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbZLOMOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 07:14:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62466 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760041AbZLOMOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 07:14:09 -0500
Subject: Re: linux-next: manual merge of the voltage tree with Linus' tree
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Valentin <eduardo.valentin@nokia.com>,
       Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
       Balaji T K <balajitk@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1260870485.3591.25.camel@odin>
References: <20091215133808.cd3d4b8b.sfr@canb.auug.org.au>
	 <1260870485.3591.25.camel@odin>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 12:14:02 +0000
Message-ID: <1260879242.3591.335.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 09:48 +0000, Liam Girdwood wrote:
> Hi Stephen,
> 
> On Tue, 2009-12-15 at 13:38 +1100, Stephen Rothwell wrote:
> > Hi Liam,
> > 
> > Today's linux-next merge of the voltage tree got a conflict in
> > drivers/regulator/twl-regulator.c between commit
> > 441a450554dada1c59fc06fdf068cb0eeba53c6d ("regulator: Add support for
> > twl6030 regulators") from Linus' tree and commits
> > 6360cf42ae51be5f6e6e72d6e81f202d9db0f7e9 ("twl4030-regulator: Remove
> > regulator from all groups when disabling") and
> > 3277b9fce0fcaa68d5947429e062163852ebc6fb ("twl4030-regulator: Add all TWL
> > regulators to twreg_info") from the voltage tree.
> > 
> > I cannot begin to fix this mess up.  I do wonder why the regulator patch
> > above was never in linux-next before being sent upstream yesterday
> > (Samuel?).  All I can do is use the version of the voltage tree from
> > next-20091120 (commit id b0a7a2ad0aebb35934de6d2509c73fe93a362c0e) for
> > today and hope that Liam can do the merge with Linus' tree.
> > 
> 
> Sorry about this. There were some large patch sets that did span both
> mfd and regulator recently.
> 
> I'll fix and do my pull request today.

Peter, Juha,

I've fixed up regulator for-next against upstream and now get a build
failure on twl-regulator.c (possibly related to mfd/twl-codec.c build
failure today ?)

  CC      drivers/regulator/twl-regulator.o
drivers/regulator/twl-regulator.c: In function ‘twlreg_disable’:
drivers/regulator/twl-regulator.c:158: error: ‘P1_GRP’ undeclared (first use in this function)
drivers/regulator/twl-regulator.c:158: error: (Each undeclared identifier is reported only once
drivers/regulator/twl-regulator.c:158: error: for each function it appears in.)
drivers/regulator/twl-regulator.c:158: error: ‘P2_GRP’ undeclared (first use in this function)
drivers/regulator/twl-regulator.c:158: error: ‘P3_GRP’ undeclared (first use in this function)
drivers/regulator/twl-regulator.c: At top level:
drivers/regulator/twl-regulator.c:358: error: ‘twlldo_list_voltage’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:450:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:450: error: ‘TWL_ADJUSTABLE_LDO’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:451:40: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:452:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:453:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:454:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:455:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:456:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:457:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:458:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:459:34: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:460:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:461:40: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:461: error: ‘TWL_FIXED_LDO’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:462:39: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:463:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:464:34: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:465:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:466:35: error: macro "TWL_ADJUSTABLE_LDO" requires 4 arguments, but only 3 given
drivers/regulator/twl-regulator.c:467:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:468:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:469:39: error: macro "TWL_FIXED_LDO" requires 5 arguments, but only 4 given
drivers/regulator/twl-regulator.c:474: error: ‘VAUX1_6030_VSEL_table’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:474: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:474: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:474: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:474: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:474: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:474: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:475: error: ‘VAUX2_6030_VSEL_table’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:475: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:475: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:475: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:475: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:475: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:475: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:476: error: ‘VAUX3_6030_VSEL_table’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:476: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:476: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:476: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:476: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:476: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:476: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:477: error: ‘VMMC_VSEL_table’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:477: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:477: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:477: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:477: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:477: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:477: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:478: error: ‘VPP_VSEL_table’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:478: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:478: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:478: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:478: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:478: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:478: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:479: error: ‘VUSIM_VSEL_table’ undeclared here (not in a function)
drivers/regulator/twl-regulator.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:479: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:479: warning: type defaults to ‘int’ in declaration of ‘type name’
drivers/regulator/twl-regulator.c:479: error: negative width in bit-field ‘<anonymous>’
drivers/regulator/twl-regulator.c: In function ‘twlreg_probe’:
drivers/regulator/twl-regulator.c:544: error: implicit declaration of function ‘twl4030reg_write’
make[2]: *** [drivers/regulator/twl-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Can you check this and send me patch before I issue a pull request.
Fwiw, the regulator pull request is now blocking on this issue.

Thanks.

Liam


