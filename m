Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXBQFZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXBQFZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 00:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965035AbXBQFZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 00:25:06 -0500
Received: from raven.upol.cz ([158.194.120.4]:55424 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965034AbXBQFZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 00:25:03 -0500
Date: Sat, 17 Feb 2007 06:33:39 +0100
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [pp] kbuild: asm-offsets generalized
Message-ID: <20070217053339.GB15861@flower.upol.cz>
References: <20070209141728.GA26749@uranus.ravnborg.org> <1171034599.2718.190.camel@localhost.localdomain> <E1HGbJz-0003Lc-6h@flower> <1171323696.19842.29.camel@localhost.localdomain> <20070213031044.GA17046@flower.upol.cz> <20070216155527.GA14687@flower.upol.cz> <20070216155929.GA14713@flower.upol.cz> <20070216185635.GA16601@uranus.ravnborg.org> <20070216215617.GA15861@flower.upol.cz> <1171687429.18876.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171687429.18876.49.camel@localhost.localdomain>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 03:43:49PM +1100, Rusty Russell wrote:
> On Fri, 2007-02-16 at 22:56 +0100, Oleg Verych wrote:
> > Hallo.
> 
> lguest parts look good though!

Thanks.

Well, then what about my way of doing generalization?

I.e. one-file shell script-let, rather many indistinguishable GNU make
files throughout source tree?

Sam's approach also offers using of CONGIG* options. But this has two
issues (for me, of course):

* lguest is in i386 arch, *top* Kbuild doing this for specific ARCH
(include/asm/);

* lguest wants to have private for-asm constants generated, unless CONFIG
is set, kbuild never will reach that directory.

Finally (my favorite). While i was told, that i'm doing more obfusticated
solutions, i doubt i did now: script-let makes magic more readable, and
GNU make's complications, like `$$' and various whitespace issues, do not
influence.

One thing is, that

+quiet_cmd_offsets = GEN     $@
+      cmd_offsets = $(srctree)/scripts/mkCconstants $< $@
+

can be moved in Kbuild.include with CONFIG* upgrade:
....
sed-$(CONFIG_MIPS) = mips
....
      cmd_offsets = $(srctree)/scripts/mkCconstants $< $@ $(sed-y)


Kind regards!
--
-o--=O`C  info emacs : not found
 #oo'L O  info make  : not found
<___=E M  man gcc    : not found
